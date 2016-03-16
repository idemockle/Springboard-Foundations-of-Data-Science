library(dplyr)
library(tidyr)

blahblah testing

#0. Load the data in RStudio
refine <- read.csv("refine.csv")
refine <- tbl_df(refine)
refine <- refine %>% rename("Product code / number" = Product.code...number)

#1. Clean up brand names
unique_cos <- refine %>% 
  select(company) %>% 
  distinct() %>% 
  arrange(company)

refine <- refine %>% 
  mutate(company = replace(company, company %in% unique_cos$company[1:5],"akzo")) %>% 
  mutate(company = replace(company, company %in% unique_cos$company[6:13],"philips")) %>% 
  mutate(company = replace(company, company %in% unique_cos$company[14:16],"unilever")) %>% 
  mutate(company = replace(company, company %in% unique_cos$company[17:19],"van houten"))

#2. Separate product code and number
refine <- refine %>% 
  separate(`Product code / number`, c("product_code", "number"), sep = "-")
refine$number <- as.numeric(refine$number)

#3. Add product categories
refine <- refine %>% 
  mutate(product_category = replace(product_code, product_code == "p", "Smartphone")) %>% 
  mutate(product_category = replace(product_category, product_category == "v", "TV")) %>% 
  mutate(product_category = replace(product_category, product_category == "x", "Laptop")) %>% 
  mutate(product_category = replace(product_category, product_category == "q", "Tablet"))


#4. Add full address for geocoding
refine <- refine %>% 
  unite("full_address", address, city, country, sep = ", ")

#5. Create dummy variables for company and product category
refine <- refine %>% 
  mutate(product_smartphone = as.numeric(product_code == "p"),
         product_tv         = as.numeric(product_code == "v"),
         product_laptop     = as.numeric(product_code == "x"),
         product_tablet     = as.numeric(product_code == "q"),
         company_akzo       = as.numeric(company == "akzo"),
         company_van_houten = as.numeric(company == "van houten"),
         company_unilever   = as.numeric(company == "unilever"),
         company_philips    = as.numeric(company == "philips"))

#Export csv
write.csv(refine, file = "refine_clean.csv")
