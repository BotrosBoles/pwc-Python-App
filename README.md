Flask Application on Azure Kubernetes Service (AKS) :

   This guide outlines the step-by-step process to run the Flask app locally, containerize it,
   and deploy it to Azure Kubernetes Service (AKS) using Terraform and GitHub Actions.

   
Steps:

1. Run the Flask App Locally:

     1. Clone the repository:
     
              git clone https://github.com/BotrosBoles/pwc-Python-App.git
              cd pwc-Python-App   
     2. Set up a Python virtual environment:

             python -m venv venv
             source venv/bin/activate # For Linux/Mac
             .\venv\Scripts\activate  # For Windows
     3. Install dependencies:

             pip install -r requirements.txt
     4. Run the Flask app locally:

             python run.py

2. Containerize the Flask App:

     1. Create a Dockerfile: Use the following multistage Dockerfile to build the app image:

             # Stage 1: Build Stage
             FROM python:3.9-slim AS builder

            # Set working directory
            WORKDIR /app

            # Copy only the requirements file to install dependencies
            COPY requirements.txt requirements.txt

            # Install dependencies in a temporary directory
            RUN pip install --user --no-cache-dir -r requirements.txt

            # Stage 2: Runtime Stage
            FROM python:3.9-slim

            # Set working directory
            WORKDIR /app

            # Copy the application code
            COPY . .

            # Copy the installed dependencies from the build stage
            COPY --from=builder /root/.local /root/.local

            # Update PATH for the dependencies installed in the user directory
            ENV PATH=/root/.local/bin:$PATH

            # Expose the application port
            EXPOSE 5000

            # Command to run the application
            CMD ["python", "run.py"]
   2. Build the Docker image:
  
            docker build -t Dockerfile .
   3. Run the container locally:

            docker run -p 5000:5000 flask-app:v1
   4. Push the image to Docker Hub:

            docker tag flask-app:v1 botros1/pwc-flaskapp:v1
            docker push botros1/pwc-flaskapp:v1
3.  Set Up Azure Kubernetes Service (AKS):

    1. Install Required Tools:

             az login
             choco install terraform # On Windows
    2. Terraform Configuration for AKS : this is the output of 2 resources ive created with their components, you'll find more details in my code section.

             output "resource_group_name" {
             value = azurerm_resource_group.aks.name
            }

            output "kubernetes_cluster_name" {
            value = azurerm_kubernetes_cluster.aks.name
           }
     3. Deploy the infrastructure using Terraform:

             terraform init
        
             terraform validate
        
             terraform plan
        
             terraform apply -auto-approve
        
     5. Get the AKS cluster credentials:
  
            az aks get-credentials --resource-group flaskapp-resource-group --name flaskapp-aks-cluster
4. Deploy to Kubernetes:

     1. Apply Kubernetes manifests:

             kubectl apply -f deployment.yaml
             kubectl apply -f service.yaml
     2.  Verify the deployment:

             kubectl get pods
         
             kubectl get deployments
         
             kubectl get services
     4.  Troubleshooting:

             kubectl describe pod <name of the pod>
         
             kubectl describe deploy/<name of my deplyment>
         
             kubectl config get-contexts
         
             kubectl logs pod <name of the pod>
 5. CI/CD Pipeline with GitHub Actions :

    stages : CI

             checkout code

             setup terraform

             Azure Login

             terraform init

             terraform plan

             terraform apply

             log into Docker HUb

             Build, tag, and push image to Docker Hub
    
    stages: CD


             Checkout code

             Azure Login

             Set AKS context

             Setup kubectl

             Log in to Docker Hub

             Deploy to AKS
     Notes:

           i) CI will be triggered when a new code is pushed to the main branch
          ii) CD will be triggered when CI is finalized successfully
         iii) i have used OIDC type of authentication to make the integration between GitHub actions and Azure

          az ad sp create-for-rbac --name "myServicePrincipal" --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth
          type this command and put its json output into your secret in github .

 7. Browse your application to make sure it is working as expected :

           kubectl get svc

    
<img width="661" alt="Screenshot 2024-12-21 043509" src="https://github.com/user-attachments/assets/0f03340e-7527-4dea-887f-859d4d124a4d" />

              
              


<img width="935" alt="Screenshot 2024-12-21 043608" src="https://github.com/user-attachments/assets/f01a9f24-28fa-4e55-90c5-9e701ee7d047" />


            


Then Browse :
              
              48.216.193.170:5000/users

              48.216.193.170:5000/products

              48.216.193.170:5000/users/1

              48.216.193.170:5000/users/2

 7. Delete resources: cd terraform-aks
    

     kubectl delete -f deployment.yaml
    
     kubectl delete -f service.yaml
    
     terraform destroy -auto-approve

    


              
             

  
            
    



        

     


     



