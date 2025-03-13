#DataSet used: https://www.kaggle.com/grouplens/movielens-20m-dataset

from pyspark.ml.recommendation import ALS
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lit
from pyspark.sql.types import FloatType, IntegerType, StringType, StructType

#Get our spark session
spark = SparkSession.builder.getOrCreate()

#Get list of movies
schema = StructType() \
      .add("movieId", IntegerType(), False) \
      .add("title", StringType(), False) \
      .add("genres", StringType(), False)

movies = spark.read.option("header", "true").schema(schema).csv("C:\\datasets\\movielens\\movie.csv")

#Get list of ratings
schema = StructType() \
      .add("userId", IntegerType(), False) \
      .add("movieId", IntegerType(), False) \
      .add("rating", FloatType(), False) \
      .add("timestamp", StringType(), True)

ratings = spark.read.option("header", "true").schema(schema).csv("C:\\datasets\\movielens\\rating.csv")

ratings = ratings.drop("timestamp")

#Add new user ratings
schema = StructType() \
      .add("userId", IntegerType(), False) \
      .add("movieId", IntegerType(), False) \
      .add("rating", IntegerType(), False)

data = [(0, 7123, 4),
      (0, 29, 4),
      (0, 1199, 5),
      (0, 27773, 5),
      (0, 4036, 4),
      (0, 1035, 1)]

newUserRatings = spark.createDataFrame(data=data, schema=schema)

ratings = ratings.union(newUserRatings)


#Train our model
als = ALS(maxIter=5, regParam=0.01, userCol='userId', itemCol='movieId', ratingCol='rating')
model = als.fit(ratings)

#Get model predictions
moviesWithHighRatings = ratings.groupBy("movieId").count().filter("count > 100")

predictionsInput = moviesWithHighRatings.select("movieId").withColumn("userId", lit(0))

predictionsInput = predictionsInput.join(newUserRatings, predictionsInput.movieId == newUserRatings.movieId, "left_anti")

predictions = model.transform(predictionsInput)

#Show New User Ratings
newUserRatings.join(movies, newUserRatings.movieId == movies.movieId, "inner") \
      .where("userId = 0") \
      .show(truncate=False)

#Show Recommendations
predictions.join(movies, predictions.movieId == movies.movieId, "inner") \
      .sort(col("prediction").desc()) \
      .show(n=30, truncate=False)