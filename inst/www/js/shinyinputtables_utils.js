const DATA_MAP = new Map([
  ["class" , "cell.class"],
  ["value" , "cell.value"],
  ["tagName" , "cell.tag"],
  ["data-cell_label", "row-col"]
]);

class InputTableUtils {
  
  // extract specified data attributes from table elements
  // el.value: https://stackoverflow.com/a/222824
  // to get current input element values need to use el.value
  // because getAttribute("value") = value at element creation
  static createAttrDataObj(el){
    var res = {};
    DATA_MAP.forEach(function(value, key, map) {
      if(el.hasAttribute(key)){
      
        if(key == "value"){
          res[value] = el.value; 
        } else if (key == "data-cell_label"){
          var refNames = value.split('-');
          var refVals = el.getAttribute(key).split('-');
          res["cell."+ refNames[0]] = refVals[0];
          res["cell."+ refNames[1]] = refVals[1];
        } else {
          res[value] = el.getAttribute(key); 
        }
        
      }
    });
    return res;
  }
  
  // gets the shiny div container parent of the input table
  // https://stackoverflow.com/q/10539419
  // getting element by tagName as id not always guaranteed
  static getParentId(el){
    return $(el).parents('div[class^="shiny"]').prop("id");
  }

  // Finding matching class in REGEX:
  // https://stackoverflow.com/a/5424544
  static containsRegex(a, regex){
    for(var i = 0; i < a.length; i++){
      if(a[i].search(regex) > -1){
        return i;
      }
    }
    return -1;
  }
  
  // easiest to manually escape single quote char
  // this is the only char not handled by the 
  // encodeURIComponent() function AFAIK.
  static urlEncodeData(jsObject){
    for(var name in jsObject){
      var value = jsObject[name].replace("'", "%27");
      jsObject[name] = encodeURIComponent(value);
    }
    return jsObject;
  }
  
  // convert to JSON string before dispatch
  // thanks @ www.jsonlint.com
  // thanks @ https://www.w3schools.com/js/js_json_objects.asp
  static createEventJSON(el){
    // 1. create plain javascript objects. Names have to be string instead of
    // bare names as "." name sep illegal in JS, though fine in R
    var resultObj = this.createAttrDataObj(el);                        
    resultObj['parent.id'] = this.getParentId(el);
    
    // 2. URL encode then convert to JSON string via JSON.stringify()
    return JSON.stringify(this.urlEncodeData(resultObj));
  }
  
}