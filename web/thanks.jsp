<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Murach's Java Servlets and JSP</title>
    <link rel="stylesheet" href="styles/main.css">
</head>
<body>
    <div class = "container">
        <h1>Thanks for filling out our survey</h1>

        <p>Here is the information that you entered:</p>

        <label>First Name:</label>
        <span>${user.firstName}</span><br>

        <label>Last Name:</label>
        <span>${user.lastName}</span><br>

        <label>Email:</label>
        <span>${user.email}</span><br>

        <label>Date of Birth:</label>
        <span>${user.dob}</span><br>

        <label>How did you hear about us?</label>
        <span>${user.referral}</span><br>

        <label>Receive announcements?</label>
        <span>${empty user.like_that ? 'No' : 'Yes'}</span><br>

        <label>Receive email announcements?</label>
        <span>${empty user.email_announcements ? 'No' : 'Yes'}</span><br>

        <label>Contact Method:</label>
        <span>${user.contact_method}</span><br>

        <p class="advice">To return to the survey, click on the Return button.</p>

                <form action="index.html" method="get">
            <input type="submit" value="Return">
        </form>
    </div>
</body>
</html>