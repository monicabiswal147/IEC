**Steps to create a Static website using S3 bucket and AWS CLI**

Create a general purpose bucket
```
aws s3api create-bucket --bucket iec-mon --region us-east-1
```
Enable public access for the bucket
```
aws s3api put-public-access-block \
      --bucket iec-mon \
      --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false" --profile mon
```
Add a public read access policy to the bucket
```
aws s3api put-bucket-policy --bucket iec-mon --profile mon --policy '{
  "Version": "2012-10-17",
  "Statement": [                                                                                                                                          
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::iec-mon/*"
    }
  ]
}'

```
Upload index.html and logo.png 

```
aws s3 cp index.html s3://iec-mon/
aws s3 cp icon.png s3://iec-mon/
```
Access the website using the below url

https://iec-mon.s3.us-east-1.amazonaws.com/index.html

####################################################

To Deploy the static website using Github workflow.

```
Go to Github actions -> Deploy Static website using S3 -> Run the workflow to deploy the website using s3
```


