vcl 4.0;

backend app_web {
    .host = "app.web";
    .port = "80";
    .connect_timeout = 6000s;
    .first_byte_timeout = 6000s;
    .between_bytes_timeout = 6000s;
}
 
backend app_web_multi {
    .host = "app.web.multi";
    .port = "80";
    .connect_timeout = 6000s;
    .first_byte_timeout = 6000s;
    .between_bytes_timeout = 6000s;
}


sub vcl_recv {
	# Default backend is set to app_web
	set req.backend_hint = app_web_multi;
	 
	if (req.http.host == "default.local") {
	    set req.backend_hint = app_web;
	}

	unset req.http.Forwarded;

    // Add a Surrogate-Capability header to announce ESI support.
    set req.http.Surrogate-Capability = "abc=ESI/1.0";

    if (req.http.X-Forwarded-Proto == "https" ) {
        set req.http.X-Forwarded-Port = "443";
    } else {
        set req.http.X-Forwarded-Port = "80";
    }

    // Remove all cookies except the session ID.
    if (req.http.Cookie) {
        set req.http.Cookie = ";" + req.http.Cookie;
        set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
        set req.http.Cookie = regsuball(req.http.Cookie, ";(PHPSESSID)=", "; \1=");
        set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

        if (req.http.Cookie == "") {
            // If there are no more cookies, remove the header to get page cached.
            unset req.http.Cookie;
        }
    }
}

sub vcl_backend_response {
    // Check for ESI acknowledgement and remove Surrogate-Control header
    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        unset beresp.http.Surrogate-Control;
        set beresp.do_esi = true;
    }
}
