import requests
import numpy as np

def main():
    print("Hello from your Python project!")
    response = requests.get("https://api.github.com/events")
    print(f"GitHub API status: {response.status_code}")
    data = np.array([1, 2, 3, 4, 5])
    print(f"Numpy array: {data}")

if __name__ == "__main__":
    main()