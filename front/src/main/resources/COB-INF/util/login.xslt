<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" version="2.0">
    
    <!-- 
        Authentication failed.
        Generate data from the request:
        
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
        <h:request xmlns:h="http://apache.org/cocoon/request/2.0" target="/front/signon.htm" sitemap="signon.htm" source="">
        <h:requestHeaders>
        <h:header name="Host">localhost:8888</h:header>
        <h:header name="Accept">application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5</h:header>
        <h:header name="User-Agent">Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; nl-nl) AppleWebKit/531.22.7 (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7</h:header>
        <h:header name="Accept-Language">nl-nl</h:header>
        <h:header name="Accept-Encoding">gzip, deflate</h:header>
        <h:header name="Cookie">AWSUSER_ID=awsuser_id1274180417270r3288</h:header>
        <h:header name="Connection">keep-alive</h:header>
        <h:header name="Content-Type">application/x-www-form-urlencoded</h:header>
        <h:header name="Referer">http://localhost:8888/front/index.html</h:header>
        <h:header name="Origin">http://localhost:8888</h:header>
        <h:header name="Content-Length">40</h:header>
        <h:header name="Cache-Control">max-age=0</h:header>
        </h:requestHeaders>
        <h:requestParameters>
        <h:parameter name="update">
        <h:value>Login</h:value>
        </h:parameter>
        <h:parameter name="username">
        <h:value>admin</h:value>
        </h:parameter>
        <h:parameter name="password">
        <h:value>xxx</h:value>
        </h:parameter>
        </h:requestParameters>
        <h:configurationParameters/>
        <h:remoteUser/>
        </h:request>

        and transform it to 
        
        <add-first-user><username>admin</username><password>xxx</password></add-first-user>
    -->
    <xsl:template match="/">
        <login>
            <username>
                <xsl:value-of select="//h:parameter[@name='username']/h:value"/>
            </username>
            <password><xsl:value-of select="//h:parameter[@name='password']/h:value"/></password>
        </login>
    </xsl:template>
    
</xsl:stylesheet>
