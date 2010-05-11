/*
 * BDXSD
 * Het flowscript om tekstblokken- en schemabestanden te uploaden.
 * Be Value, 2007/2008
 * Huib Verweij.
 */

/*
* upload a file
*/
function uploadFile() {
    var errors = null;
    var dom = null;
    var request = cocoon.request;
    try {
        var map = request.getParameters();
        for (var key in paramMap) {
              var part = request.getParameter(key);
              var destination = cocoon.parameters.path + "/" + key;
              try {
                    var file = new java.io.File(part);
                    org.apache.commons.io.FileUtils.copyFile(file, new java.io.File(destination));
                    break;
               } catch (ex) {
                  cocoon.log.info(ex.message, null);
                  cocoon.sendPage("flow-report", {
                     'XML': generateReport(null, 'failed', 'Upload ' + (null != file ? 'van  "' + file.getName() +'" ' : ' ') + 'is mislukt.' + ex.message,  (null != file ? file.getName() : ''))
                  });
                  return;
               }
        }
        var part = request.getParameter("textblox");
        dom = callPipeline("msword-2-lexer?documentontwerp=" + part);
        checkForErrors(dom);
        
        var destination = cocoon.parameters.path + "/" + "textblox.doc";
        var file = new java.io.File(part);
        org.apache.commons.io.FileUtils.copyFile(file, new java.io.File(destination));

        callPipeline("component/edit-setup", {'filename' : file.getName(), 'id' : 'textblox.doc', 'uploadDatetime' : new Date().toISOString()});
        
        cocoon.sendPage("flow-report", {
            'XML' : generateReport(dom, "ok", "Upload gelukt.", part)
        });
        return;
    } catch (ex) {
        cocoon.log.info(ex.message, null);
        cocoon.sendPage("flow-report", {
           'XML': generateReport(dom, 'failed', "Het importeren van het standaard-tekstblokken bestand is mislukt." + ex.message, part)
        });
        return;
    }
}

/*
* upload een schema bestand
*/
function uploadSchema() {
    var acceptableSchemaNames = new Array("BODYELEM.xsd", "DATATYPE.xsd", "mhstypen.xsd");
    var request = cocoon.request;
    var standardFilename = request.getParameter("standardFilename");
    var part = request.getParameter("schema");
    var file = null;
    var standardFile = null;
    try {
        file = new java.io.File(part);
        standardFile = new java.io.File(standardFilename);
        var name = standardFile.getName();
        var ok = false;
        for (var i = 0; i < acceptableSchemaNames.length; i++) {
            if (acceptableSchemaNames[i] == name) {
                ok = true;
                break;
            }
        }
        if ( ! ok) {
            var myUserException = new UserException('U kunt alleen ' + acceptableSchemaNames.join(", ") + ' uploaden, u probeerde "' + name + '" te uploaden.');
            throw myUserException;
        } 
        var destination = cocoon.parameters.path + "/" + standardFilename;
        org.apache.commons.io.FileUtils.copyFile(file, new java.io.File(destination));
        
        var dom = callPipeline("component/edit-setup", {'filename' : file.getName(), 'id' : name, 'uploadDatetime' : new Date().toISOString()});
        
        cocoon.redirectTo("beheer.html", true);
    } catch (ex) {
        cocoon.log.info(ex.message, null);
        cocoon.sendPage("flow-report", {
           'XML': generateReport(null, 'failed', 'Upload ' + (null != file ? 'van  "' + file.getName() +'" ' : ' ') + 'is mislukt.' + ex.message,  (null != file ? file.getName() : ''))
        });
        return;
    }
}



