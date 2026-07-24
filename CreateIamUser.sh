#!/bin/bash


# Create Group

aws iam create-group --group-name devops

#Attach Administrator Policy

aws iam attach-group-policy --group-name devops --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

#Create User

aws iam create-user --user-name devops-demo

#Attach Group to user

aws iam add-user-to-group --group-name devops --user-name devops-demo


