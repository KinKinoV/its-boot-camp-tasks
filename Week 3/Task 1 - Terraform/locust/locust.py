from locust import HttpUser, task, between

class EC2ASGTest(HttpUser):

    @task
    def simulate_load(self):
        self.client.get(url="/tools/load")
