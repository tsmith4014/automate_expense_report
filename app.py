
"""
This script defines a Flask app that generates an Excel file based on the data submitted through a form, using a pre-defined template.
The app has two routes: 
    - '/' renders a form for inputting data
    - '/generate-excel' generates an Excel file based on the data submitted through the form and returns it as an attachment.
"""
from flask import Flask, render_template, request, send_file
from populate_excel import populate_template

app = Flask(__name__)

@app.route('/', methods=['GET'])
def form():
    # Render a form for inputting data
    return render_template('index.html')

@app.route('/generate-excel', methods=['POST'])
def generate_excel():
    """
    Generates an Excel file based on the data submitted through a form, using a pre-defined template.

    Returns:
        The generated Excel file as an attachment.
    """
    # Get data from form
    data = {
        'school': request.form['school'],
        'period_ending': request.form['periodEnding'],
        'trip_purpose': request.form['tripPurpose']
    }

    # Define paths
    template_path = 'expense_report.xlsx'
    output_path = 'output.xlsx'

    # Populate the template
    populate_template(data, template_path, output_path)

    # Send the populated Excel file to the user
    return send_file(output_path, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True)
