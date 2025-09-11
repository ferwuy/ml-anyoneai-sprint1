# Sprint project 01
> E-Commerce Data Pipeline

Hi! this is the first of several projects we're going to be working on during this course.
You will be expected to finish this project on your own, but you can use the available channels on Discord to ask questions and help others. 

Please go through this `README` file before starting. It will give you a better idea of what you need to accomplish.

## The Business problem

You are working for one of the largest e-commerce sites in Latam and they requested the Data Science team to analyze company data and make visualizations to better understand the company's performance on specific metrics during the years 2016-2018.

There are two main areas they want to explore: **Revenue** and **Delivery**.

Basically, they would like to understand how much revenue they got each year, which were the most and least popular product categories, and how much revenue they got in each state. On the other hand, it's important to know how effectively the company is delivering the sold products to their users. For example, by identifying the difference between the estimated delivery date and the real one, for each month and state.

## About the data

You will consume and use data from two sources.

The first one is a Brazilian e-commerce public dataset of orders made at the Olist Store, provided as CSVs files. This is real commercial data, that has been anonymized. The dataset has information on 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allow viewing orders from multiple dimensions: order status, delivery date, product information, customer information, geolocation, customer reviews, among others. You will find an image showing the database schema at `images/data_schema.png`. 

- To get the dataset, please download it from this [link](https://drive.google.com/file/d/1HIy4LNNQESuXUj-u_mNJTCGCRrCeSbo-/view?usp=share_link), extract the `dataset` folder from the `.zip` file, and place it into the root project folder. See `ASSIGNMENT.md`, section **Project Structure** to validate you've placed the dataset as it's needed.

The second source is a public API: https://date.nager.at. You will use it to retrieve information about Brazil's Public Holidays and correlate it with certain metrics about product delivery.

## Technical aspects

Because the team knows the data will come from different sources and formats, you will probably have to provide these kinds of reports on a monthly or annual basis. They decided to build a data pipeline (ELT) that they can execute from time to time to produce the results. You will have to go through the steps outlined in `ASSIGNMENT.md` to build this pipeline.

The technologies involved are:
- Python as the main programming language
- Pandas for consuming data from CSVs files
- Requests for querying the public holidays API
- SQLite as a database engine
- SQL as the main language for storing, manipulating, and retrieving data in our Data Warehouse
- Matplotlib and Seaborn for the visualizations
- Jupyter notebooks to make the report an interactive way

## Instalation

A `requirements.txt` file is provided with all the needed Python libraries for running this project. For installing the dependencies just run:

```console
$ pip install -r requirements.txt
```

*Note:* We encourage you to install those inside a virtual environment using Python 3.9.

## Code Style

Following a style guide keeps the code's aesthetics clean and improves readability, making contributions and code reviews easier. Automated Python code formatters make sure your codebase stays in a consistent style without any manual work on your end. If adhering to a specific style of coding is important to you, employing an automated to do that job is the obvious thing to do. This avoids bike-shedding on nitpicks during code reviews, saving you an enormous amount of time overall.

We use [Black](https://black.readthedocs.io/) for automated code formatting in this project, you can run it with:

```console
$ black --line-length=88 .
```

Wanna read more about Python code style and good practices? Please see:
- [The Hitchhiker’s Guide to Python: Code Style](https://docs.python-guide.org/writing/style/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)

## Tests

We provide unit tests along with the project that you can run and check from your side the code meets the minimum requirements of correctness needed to approve. To run just execute:

```console
$ pytest tests/
```

If you want to learn more about testing Python code, please read:
- [Effective Python Testing With Pytest](https://realpython.com/pytest-python-testing/)
- [The Hitchhiker’s Guide to Python: Testing Your Code](https://docs.python-guide.org/writing/tests/)


### ** DATABASE olist.db

To perform exploratory analysis on the database tables, we will first examine the columns in each table and then identify how the tables relate to one another based on their schema. Here's the breakdown:

---

### **1. Table Overview and Columns**

#### **`olist_customers`**
- **Columns**:
  - `customer_id`: Unique identifier for each customer.
  - `customer_unique_id`: Another unique identifier for customers (possibly used for deduplication).
  - `customer_zip_code_prefix`: ZIP code prefix of the customer.
  - `customer_city`: City of the customer.
  - `customer_state`: State of the customer.

#### **`olist_geolocation`**
- **Columns**:
  - `geolocation_zip_code_prefix`: ZIP code prefix for geolocation data.
  - `geolocation_lat`: Latitude of the location.
  - `geolocation_lng`: Longitude of the location.
  - `geolocation_city`: City corresponding to the ZIP code.
  - `geolocation_state`: State corresponding to the ZIP code.

#### **`olist_order_items`**
- **Columns**:
  - `order_id`: Identifier for the order.
  - `order_item_id`: Sequential number for items in the order.
  - `product_id`: Identifier for the product in the order.
  - `seller_id`: Identifier for the seller of the product.
  - `shipping_limit_date`: Deadline for shipping the product.
  - `price`: Price of the product.
  - `freight_value`: Shipping cost for the product.

#### **`olist_order_payments`**
- **Columns**:
  - `order_id`: Identifier for the order.
  - `payment_sequential`: Sequential number for payments in the order.
  - `payment_type`: Type of payment (e.g., credit card, voucher).
  - `payment_installments`: Number of installments for the payment.
  - `payment_value`: Total payment amount.

#### **`olist_order_reviews`**
- **Columns**:
  - `review_id`: Identifier for the review.
  - `order_id`: Identifier for the order being reviewed.
  - `review_score`: Score given in the review (e.g., 1-5).
  - `review_comment_title`: Title of the review comment.
  - `review_comment_message`: Detailed review comment.
  - `review_creation_date`: Date the review was created.
  - `review_answer_timestamp`: Timestamp when the review was answered.

#### **`olist_orders`**
- **Columns**:
  - `order_id`: Identifier for the order.
  - `customer_id`: Identifier for the customer who placed the order.
  - `order_status`: Status of the order (e.g., delivered, canceled).
  - `order_purchase_timestamp`: Timestamp when the order was placed.
  - `order_approved_at`: Timestamp when the order was approved.
  - `order_delivered_carrier_date`: Date the order was delivered to the carrier.
  - `order_delivered_customer_date`: Date the order was delivered to the customer.
  - `order_estimated_delivery_date`: Estimated delivery date for the order.

#### **`olist_products`**
- **Columns**:
  - `product_id`: Identifier for the product.
  - `product_category_name`: Category of the product.
  - `product_name_lenght`: Length of the product name.
  - `product_description_lenght`: Length of the product description.
  - `product_photos_qty`: Number of photos for the product.
  - `product_weight_g`: Weight of the product in grams.
  - `product_length_cm`: Length of the product in centimeters.
  - `product_height_cm`: Height of the product in centimeters.
  - `product_width_cm`: Width of the product in centimeters.

#### **`olist_sellers`**
- **Columns**:
  - `seller_id`: Identifier for the seller.
  - `seller_zip_code_prefix`: ZIP code prefix for the seller.
  - `seller_city`: City of the seller.
  - `seller_state`: State of the seller.

#### **`product_category_name_translation`**
- **Columns**:
  - `product_category_name`: Original category name of the product.
  - `product_category_name_english`: Translated category name in English.

#### **`public_holidays`**
- **Columns**:
  - `date`: Date of the public holiday.
  - `localName`: Local name of the holiday.
  - `name`: General name of the holiday.
  - `countryCode`: Country code where the holiday is observed.
  - `fixed`: Whether the holiday is fixed (TRUE/FALSE).
  - `global`: Whether the holiday is global (TRUE/FALSE).
  - `launchYear`: Year the holiday was first observed.

---

### **2. Relationships Between Tables**

Based on the schema, here are the relationships:

1. **`olist_customers` ↔ `olist_orders`**:
   - `olist_customers.customer_id` is linked to `olist_orders.customer_id`.

2. **`olist_orders` ↔ `olist_order_items`**:
   - `olist_orders.order_id` is linked to `olist_order_items.order_id`.

3. **`olist_orders` ↔ `olist_order_payments`**:
   - `olist_orders.order_id` is linked to `olist_order_payments.order_id`.

4. **`olist_orders` ↔ `olist_order_reviews`**:
   - `olist_orders.order_id` is linked to `olist_order_reviews.order_id`.

5. **`olist_order_items` ↔ `olist_products`**:
   - `olist_order_items.product_id` is linked to `olist_products.product_id`.

6. **`olist_order_items` ↔ `olist_sellers`**:
   - `olist_order_items.seller_id` is linked to `olist_sellers.seller_id`.

7. **`olist_products` ↔ `product_category_name_translation`**:
   - `olist_products.product_category_name` is linked to `product_category_name_translation.product_category_name`.

8. **`olist_customers` ↔ `olist_geolocation`**:
   - `olist_customers.customer_zip_code_prefix` is linked to `olist_geolocation.geolocation_zip_code_prefix`.

9. **`olist_sellers` ↔ `olist_geolocation`**:
   - `olist_sellers.seller_zip_code_prefix` is linked to `olist_geolocation.geolocation_zip_code_prefix`.

---

### **3. Summary of Key Relationships**
- Orders (`olist_orders`) are central to the schema, connecting customers, products, sellers, payments, and reviews.
- Geolocation data can be used to analyze customer and seller locations.
- Product categories can be translated using the `product_category_name_translation` table.
- Public holidays (`public_holidays`) can be used to analyze the impact of holidays on orders, deliveries, or reviews.
