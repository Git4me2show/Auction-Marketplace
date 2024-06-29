<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Auction Listing Form</title>
    <style>
        /* Style for the navbar */
        .navbar {
            overflow: hidden;
            background-color: #333;
        }

        .navbar a {
            float: left;
            display: block;
            color: #f2f2f2;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
        }

        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }

        /* Style for the form */
        form {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        label {
            font-weight: bold;
        }
        h1 {
            text-align: center; /* Center align the h1 */
        }

        select, input[type="text"], input[type="number"], input[type="date"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            width: 100%;
            background-color: #333;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #ddd;
            color: black;
        }
    </style>
    <script>
        function updateDropdown() {
            var primarySelect = document.getElementById('category');
            var secondarySelect = document.getElementById('subCategory');
            var category = primarySelect.value;
            var options = [];

            switch(category) {
                case 'Electronics':
                    options = ['Speaker', 'Mouse', 'Other'];
                    break;
                case 'Laptop':
                    options = ['Dell', 'Lenovo', 'Other'];
                    break;
                case 'Mobile':
                    options = ['Samsung', 'Apple', 'Other'];
                    break;
                case 'Television':
                    options = ['Samsung', 'Sony', 'Other'];
                    break;
                default:
                    options = []; // Clear options if no category or invalid category is selected
            }

            // Clear existing options in subcategory dropdown
            secondarySelect.innerHTML = '';

            // Create a placeholder option
            var placeholder = document.createElement('option');
            placeholder.textContent = 'Select a Field';
            placeholder.value = '';
            secondarySelect.appendChild(placeholder);

            // Append new options
            options.forEach(function(option) {
                var opt = document.createElement('option');
                opt.value = option;
                opt.textContent = option;
                secondarySelect.appendChild(opt);
            });
        }
    </script>
</head>
<body>
    <div class="navbar">
        <a onclick="location.href='home.jsp'">Home</a>
    </div>

    <h1>Post Your Auction Listing</h1>
    <form action="insertListing.jsp" method="post">
        <label for="category">Choose a category:</label><br>
        <select id="category" name="category" onchange="updateDropdown()" required>
            <option value="">Select a Category</option>
            <option value="Electronics">Electronics</option>
            <option value="Laptop">Laptop</option>
            <option value="Mobile">Mobile</option>
            <option value="Television">Television</option>
        </select><br><br>

        <label for="subCategory">Choose a subcategory:</label><br>
        <select id="subCategory" name="subCategory" required>
            <option value="">Select a Field</option>
            <!-- Options will be added here based on the first dropdown's selection -->
        </select><br><br>

        <label for="closeDate">Close Date:</label><br>
        <input type="date" id="closeDate" name="closeDate" required><br><br>
        
        <label for="itemName">Item Name:</label><br>
        <input type="text" id="itemName" name="itemName" required><br>
        
        <label for="description">Description:</label><br>
        <input type="text" id="desc" name="desc" required><br>
        
        <label for="minPrice">Minimum Price ($):</label><br>
        <input type="text" id="minPrice" name="minPrice" required><br>
        
        <label for="startPrice">Starting Price ($):</label><br>
        <input type="number" id="price" name="price" step="0.01" required><br>

        <input type="submit" value="Submit Listing">
    </form>
</body>
</html>
