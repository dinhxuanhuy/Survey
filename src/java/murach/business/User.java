package murach.business;

import java.io.Serializable;

public class User implements Serializable {
    
    private String firstName;
    private String lastName;
    private String email;
    private String dob;
    private String referral;
    private String like_that;
    private String contact_method;
    private String email_announcements;

    public User() {
        firstName = "";
        lastName = "";
        email = "";
        dob = "";
        referral = "";
        like_that = "";
        email_announcements = ""; 
        contact_method = "";
        
    }

    public User(String firstName, String lastName, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.dob = "";
        this.referral = "";
        this.like_that = "";
        this.email_announcements = "";
        this.contact_method = "";
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getReferral() {
        return referral;
    }

    public void setReferral(String referral) {
        this.referral = referral;
    }

    public String getLike_that() {
        return like_that;
    }

    public void setLike_that(String like_that) {
        // Xử lý giá trị null từ checkbox (nếu không được chọn)
        if (like_that == null) {
            this.like_that = "";
        } else {
            this.like_that = like_that;
        }
    }
    public String getEmail_announcements() {
        return email_announcements;
    }

    public void setEmail_announcements(String email_announcements) {
        // Xử lý giá trị null từ checkbox (nếu không được chọn)
        if (email_announcements == null) {
            this.email_announcements = "";
        } else {
            this.email_announcements = email_announcements;
        }
    }

    public String getContact_method() {
        return contact_method;
    }

    public void setContact_method(String contact_method) {
        this.contact_method = contact_method;
    }
}