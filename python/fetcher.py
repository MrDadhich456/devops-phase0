import requests
import argparse
import logging
import json

# Configure logging to output cleanly to the console
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')


def fetch_posts(user_id):
    url = 'https://jsonplaceholder.typicode.com/posts'

    try:
        # 1. Make the GET request using the requests library
        response = requests.get(url)

        # 2. Check if the HTTP status code is 200 (OK)
        if response.status_code == 200:
            data = response.json()

            # 3. Filter the data using a list comprehension.
            # Keep only the posts where the 'userId' matches the user_id passed
            # to the function
            filtered_data = [p for p in data if p['userId'] == user_id]

            if not filtered_data:
                logging.warning(f"No posts found for user ID {user_id}")
                return

            # 4. Save the filtered_data to 'posts.json' with an indent of 2
            with open('posts.json', 'w') as f:
                json.dump(filtered_data, f, indent=2)

            logging.info(f"Successfully saved {len(filtered_data)} posts to posts.json")

        else:
            logging.error(f"API returned bad status code: {response.status_code}")

    # Handle network drops and bad URLs gracefully
    except requests.exceptions.ConnectionError:
        logging.error("Failed to connect. Check your internet or the URL.")
    except requests.exceptions.Timeout:
        logging.error("The API request timed out.")


if __name__ == '__main__':
    # 5. Set up argparse so the script accepts a --user-id flag
    parser = argparse.ArgumentParser(
        description="Fetch JSON posts for a specific user.")

    # Add the argument. Make sure the type is int!
    parser.add_argument(
        '--user-id',
        type=int,
        required=True,
        help="The ID of the user to fetch posts for")

    args = parser.parse_args()

    logging.info(f"Starting fetch for user ID: {args.user_id}")

    # Call the function with the argument provided in the terminal
    fetch_posts(args.user_id)
