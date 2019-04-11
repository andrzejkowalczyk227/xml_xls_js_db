function loadXML(name)
{
	if(window.ActiveXObject) // dla IE
	{
		xhttp = new ActiveXObject("Msxml2.XMLHTTP");
	}
	else // reszta
	{
		xhttp = new XMLHttpRequest();
	}
	xhttp.open("GET", name, false);
	try // dla IE
	{
		xhttp.responseType = "msxml-document"
	} catch (err) {}
	xhttp.send("");
	return xhttp.responseXML;
}

function transform()
{
	var xml = loadXML("http://localhost:8000/klienci/Wypozyczalnia.xml");
    var xsl = loadXML("http://localhost:8000/klienci/transKlienci.xsl");
	
	if (window.ActiveXObject) // IE
	{
        var template = new ActiveXObject('Msxml2.XslTemplate');
        template.stylesheet = xsl;
        var proc = template.createProcessor();
        proc.input = xml;
        proc.addParameter('pWlasnosc', wlasnosc);
		proc.addParameter('pWartosc', wartosc);
        proc.transform();
        document.getElementById("container").innerHTML = proc.output;
    }
	else if (typeof XSLTProcessor !== 'undefined') 
	{
        var xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xsl);
		
		var resultDocument = xsltProcessor.transformToDocument(xml);
		var serializer = new XMLSerializer();
        var transformed = serializer.serializeToString(resultDocument.documentElement);
		var wnd = window.open("about:blank");
		wnd.document.write(transformed);
    }
}

function transformWithParams(wlasnosc,wartosc)
{
	var xml = loadXML("http://localhost:8000/Wypozyczalnia.xml");
    var xsl = loadXML("http://localhost:8000/transFiltrWlasnoscWartosc.xsl");
	
	if (window.ActiveXObject) // IE
	{
        var template = new ActiveXObject('Msxml2.XslTemplate');
        template.stylesheet = xsl;
        var proc = template.createProcessor();
        proc.input = xml;
        proc.addParameter('pWlasnosc', wlasnosc);
		proc.addParameter('pWartosc', wartosc);
        proc.transform();
        document.getElementById("container").innerHTML = proc.output;
    }
	else if (typeof XSLTProcessor !== 'undefined') 
	{
        var xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xsl);
        xsltProcessor.setParameter(null,"pWlasnosc", wlasnosc);
		xsltProcessor.setParameter(null,"pWartosc", wartosc);
        //var resultFragment = xsltProcessor.transformToFragment(xml, document);
		//document.getElementById("container").appendChild(resultFragment);
		
		var resultDocument = xsltProcessor.transformToDocument(xml);
		var serializer = new XMLSerializer();
        var transformed = serializer.serializeToString(resultDocument.documentElement);
		var wnd = window.open("about:blank");
		wnd.document.write(transformed);
    }
}

function transformWithParam(typ)
{
	var xml = loadXML("http://localhost:8000/Wypozyczalnia.xml");
    var xsl = loadXML("http://localhost:8000/transFiltrTypPrzedmiotu.xsl");
	
	if (window.ActiveXObject) // IE
	{
        var template = new ActiveXObject('Msxml2.XslTemplate');
        template.stylesheet = xsl;
        var proc = template.createProcessor();
        proc.input = xml;
        proc.addParameter('pTyp', typ);
        proc.transform();
        document.getElementById("container").innerHTML = proc.output;
    }
	else if (typeof XSLTProcessor !== 'undefined') 
	{
        var xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xsl);
        xsltProcessor.setParameter(null,'pTyp', typ);
        //var resultFragment = xsltProcessor.transformToFragment(xml, document);
		//document.getElementById("container").appendChild(resultFragment);
		
		var resultDocument = xsltProcessor.transformToDocument(xml);
		var serializer = new XMLSerializer();
        var transformed = serializer.serializeToString(resultDocument.documentElement);
		var wnd = window.open("about:blank");
		wnd.document.write(transformed);
    }
}

function wyswietlPoDowolnych()
{
	var wlasnosc = (document.getElementById("inputWlasnosc")).value;
	var wartosc = (document.getElementById("inputWartosc")).value;
	transformWithParams(wlasnosc, wartosc);
}

function wyswietlTrudnosciami()
{
	var vSelect = (document.getElementById("trudnoscSelect")).value;
	transformWithParams("Trudnosc", vSelect );
}

function wyswietlPoPrzedmiotach()
{
	var vSelect = (document.getElementById("typSelect")).value;
	transformWithParam(vSelect);
}

function wyswietlKlientow()
{
	transform();
}