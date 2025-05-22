import json
import sys
import numpy as np
import simpy
import pandas as pd

# Read input from stdin
input_json = sys.stdin.read()
app_input = json.loads(input_json)

#Environment
np.random.seed(42)
env = simpy.Environment()
stats = []

# === RESOURCE CLASS ===
class Process:
    def __init__(self, env, config):
        self.name = config["resource_name"]
        self.order = config["resource_order"]
        self.env = env
        self.config = config
        self.resource = simpy.Resource(env, capacity=int(config["resource_capacity"]))

    def service_time(self):
        dist = self.config["resource_time_distribution"]
        mean = self.config["resource_time_mean"]
        std = self.config["resource_time_variance"] ** 0.5
        if dist == "Exponential":
            return np.random.exponential(mean)
        else:
            return max(0, np.random.normal(mean, std))

# === ENTITY CLASS ===
class Arrival:
    def __init__(self, env, processes, entity_id):
        self.env = env
        self.processes = processes
        self.id = entity_id

    def process(self):
        for proc in self.processes:
            with proc.resource.request() as req:
                arrival_time = self.env.now
                yield req
                wait_time = self.env.now - arrival_time
                service_time = proc.service_time()
                start_service = self.env.now
                yield self.env.timeout(service_time)
                end_time = self.env.now

                stats.append({
                    "entity_id": self.id,
                    "resource": proc.name,
                    "arrival_time": arrival_time,
                    "start_service": start_service,
                    "end_time": end_time,
                    "wait_time": wait_time,
                    "service_time": service_time
                })

# === SOURCE CLASS ===
class GenerateArrivals:
    def __init__(self, env, source_config, processes):
        self.env = env
        self.source_config = source_config
        self.processes = processes
        self.entity_id = 0

    def interarrival_time(self):
        dist = self.source_config["arrival_interval_distribution"]
        mean = self.source_config["arrival_interval_mean"]
        std = self.source_config["arrival_interval_variance"] ** 0.5
        if dist == "Exponential":
            return np.random.exponential(mean)
        else:
            return max(0, np.random.normal(mean, std))

    def start(self, debug=False):
        while True:
            arrival = Arrival(self.env, self.processes, self.entity_id)
            self.env.process(arrival.process())
            self.entity_id += 1
            iat = self.interarrival_time()
            if debug:
                print(f"[{self.env.now:.2f}] Next arrival in {iat:.2f}")
            yield self.env.timeout(iat)

# --- RESOURCE INSTANTIATION ---
resource_configs = sorted(app_input["resources"], key=lambda r: r["resource_order"])
resources = [Process(env, cfg) for cfg in resource_configs]
source_config = app_input["sources"][0]

source = GenerateArrivals(env, source_config, resources)
env.process(source.start(debug=True))
env.run(until=app_input["scenario_length"])

print(json.dumps(results))
