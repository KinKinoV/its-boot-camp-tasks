from locust import HttpUser, task, between

class FargateECSTest(HttpUser):

    @task
    def simulate_load(self):
        self.client.get(url="/tools/load")