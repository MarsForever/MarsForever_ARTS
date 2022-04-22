```
aws --version
aws cloudformation describe-stacks
```

```sh
#create s3 buckets
PS C:\Users\marsforever> aws s3api create-bucket --bucket acg-deploy-test-bucket --region us-east-1                     
{
    "Location": "/acg-deploy-test-bucket"
}
```

https://github.com/awslabs/aws-shell

```sh
#setting aws shell
PS C:\Users\marsforever> aws-shell --profile cloudguru
```

```sh
# create the bucket using aws-shell
aws> s3api create-bucket --bucket test-my-bucket-aws-shell
{
    "Location": "/test-my-bucket-aws-shell"
}

# delete the bucket
aws> s3api delete-bucket --bucket test-my-bucket-aws-shell
aws> s3 ls
2021-11-07 20:08:31 acg-deploy-test-bucket
```

