package murach.email;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import murach.business.User;

public class EmailListServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        String url = "/index.html";
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "join";
        }

        if (action.equals("join")) {
            url = "/index.html";
        } 
        else if (action.equals("add")) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String dob = request.getParameter("dateOfBirth");
            String referral = request.getParameter("referral");
            String like_that = request.getParameter("like_that");
            String email_announcements = request.getParameter("email_announcements");
            String contact_method = request.getParameter("contact_method");

            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setDob(dob);
            user.setReferral(referral);
            user.setLike_that(like_that);
            user.setEmail_announcements(email_announcements);
            user.setContact_method(contact_method);
            
            request.setAttribute("user", user);

            url = "/thanks.jsp";
        }

        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
