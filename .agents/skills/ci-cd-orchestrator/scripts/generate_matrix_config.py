import json
import sys
import argparse

def generate_matrix(services, environments, shards):
    config = {
        "service": services.split(','),
        "env": environments.split(','),
    }
    if shards > 1:
        config["shard"] = list(range(1, shards + 1))
    
    return json.dumps(config)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--services", default="frontend,api", help="Comma-separated services")
    parser.add_argument("--envs", default="staging", help="Comma-separated envs")
    parser.add_argument("--shards", type=int, default=1, help="Number of shards")
    
    args = parser.parse_args()
    
    print(generate_matrix(args.services, args.envs, args.shards))
