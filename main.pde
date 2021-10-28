import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

String mainpath;
String xmlString;
String find;
ArrayList<String> foundlist;

void setup(){
  foundlist = new ArrayList<String>();
  mainpath = "/home/paotharit/Creature";
  xmlString = "";
  find = "dog";
  loadData();
  for ( int i = 0 ; i < foundlist.size() ; i+=2 ){  //print found file and their directory
    println(foundlist.get(i) + " in " + foundlist.get(i+1));
  }
  println("FINISH\n");
}

void draw(){
  boolean hidden = false;
  if(!hidden) {
    surface.setVisible(false);
    hidden = true;
  }
}

void updateXML(String path) {
  String[] listpath = path.split("/");
  String lastpath = listpath[listpath.length-1];
  xmlString += "<folder name=" + '"' + lastpath + '"' + ">"; 
  File[] files = listFiles(path);
  for (int i = 0 ; i < files.length ; i++){
    print(".");
    File f = files[i];
    String filename = f.getName();
    if (f.isDirectory()) {
      String nextpath = files[i].toString();
      updateXML(nextpath);
    } else {
      xmlString += "<file name=" + '"' + filename + '"' + "/>";
    }
  }
  xmlString += "</folder>";
}

void saveXml(String xml){
  //println(xml);
  XML xmlsave = parseXML(xml);
  //println("xmlsave: " + xmlsave);
  saveXML(xmlsave,"save.xml");
}

void searchFile(XML path, String searchname){
  boolean matchFound = false;
  for( int i = 0 ; i < path.getChildCount() ; i++ ){
    print(".");
    //println(path.getChild(i).getString("name"));
    if(path.getChild(i).getName().equals("folder")){ // Directory    
      try{
        Pattern pattern = Pattern.compile(searchname.charAt(0) + ".{" + (find.length()-2) + "}" + searchname.charAt(searchname.length()-1),Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(path.getChild(i).getString("name"));
        matchFound = matcher.find();  
        if(matchFound){
          searchname = matcher.group(0);
        }
      }
      catch(Exception e){
        
      }
      Pattern pattern2 = Pattern.compile(searchname,Pattern.CASE_INSENSITIVE);
      Matcher matcher2 = pattern2.matcher(path.getChild(i).getString("name"));
      boolean matchFound2 = matcher2.find();   
      
      
      if (matchFound2){
        searchname = matcher2.group(0);
      }
      
      if(path.getChild(i).getString("name").equals(searchname) && (matchFound || matchFound2)){
        print(".");
        //println("found " + searchname + " in " + path.getString("name"));
        foundlist.add(searchname);
        foundlist.add(path.getString("name"));
      }
      else if(path.getChild(i).getString("name").contains(searchname) && (matchFound || matchFound2)){
        //println("found " + path.getChild(i).getString("name") + " in " + path.getString("name"));
        foundlist.add(path.getChild(i).getString("name"));
        foundlist.add(path.getString("name"));
      }   
      searchFile(path.getChild(i),searchname);
    }
    else if(path.getChild(i).getName().equals("file")){
      try{
        Pattern pattern = Pattern.compile(searchname.charAt(0)+".{"+(find.length()-2)+"}"+searchname.charAt(searchname.length()-1),Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(path.getChild(i).getString("name"));
        matchFound = matcher.find();  
        if(matchFound){
          searchname = matcher.group(0);
        }    
      }
      catch(Exception e){
        
      }
      Pattern pattern2 = Pattern.compile(searchname,Pattern.CASE_INSENSITIVE);
      Matcher matcher2 = pattern2.matcher(path.getChild(i).getString("name"));
      boolean matchFound2 = matcher2.find();   
      
      
      if (matchFound2){
        searchname = matcher2.group(0);
      }
      
      if(path.getChild(i).getString("name").equals(searchname) && (matchFound || matchFound2)){
        print(".");
        //println("found " + searchname + " in " + path.getString("name"));
        foundlist.add(searchname);
        foundlist.add(path.getString("name"));
      }
      else if(path.getChild(i).getString("name").contains(searchname) && (matchFound || matchFound2)){
        //println("found " + path.getChild(i).getString("name") + " in " + path.getString("name"));
        foundlist.add(path.getChild(i).getString("name"));
        foundlist.add(path.getString("name"));
      }       
    }
  }
}

void loadData(){
  XML xml = loadXML("save.xml");
  if(xml != null){
    println("Using old save.xml");
    println("Searching in save.xml\n");
    searchFile(xml,find);
    println("\n");
  }else{
    println("Don't have save.xml\n");
    updateXML(mainpath);
    print("\n");
    saveXml(xmlString);
    xml = loadXML("save.xml");
    println("Create and using new save.xml\n");
    searchFile(xml,find);
    println("\n");
  }

}
