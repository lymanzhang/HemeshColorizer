/*
Hemesh Colorizer
 Copyright (C) 2013 Entertailion
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

// very primitive VRML export function for meshes; does not support the full VRML spec
// to import to Blender, first convert to 3DS using MeshLab since Blender does not support colors for VRML files
void exportVRML(String name) {
  println("exportVRML");
  StringBuffer buffer = new StringBuffer();
  buffer.append("#VRML V2.0 utf8\n");
  buffer.append("#Generated by Hemesh Colorizer http://leonnicholls.com\n");
  buffer.append("\n");
  buffer.append("Shape {\n");

  buffer.append("\tappearance Appearance {\n");
  buffer.append("\t\tmaterial Material {\n");
  buffer.append("\t\t}  #Material\n");
  buffer.append("\t} #Appearance\n");

  buffer.append("\tgeometry IndexedFaceSet {\n");

  buffer.append("\t\tcoord  DEF AllCoords Coordinate {\n");
  buffer.append("\t\tpoint [\n");

  // list vertices coordinates
  HashMap <Integer, Integer> vertexKeys = new HashMap <Integer, Integer> ();
  int counter = 0;
  Iterator <HE_Vertex> vItr = myShape.vItr();
  HE_Vertex v;
  while (vItr.hasNext ()) { 
    v = vItr.next(); 
    //println(v.key()+" "+v.xf()+","+v.yf()+","+v.zf());
    buffer.append("\t\t\t"+v.xf()+" "+v.yf()+" "+v.zf()+",\n");
    vertexKeys.put(v.key(), counter);
    counter++;
  }
  //println(counter+" vertices");

  buffer.append("\t\t] #point\n");
  buffer.append("\t\t} #Coordinate\n");

  buffer.append("\t\tcoordIndex [\n");

  // list faces vertices indexes
  counter = 0;
  Iterator <HE_Face> fItr = myShape.fItr();
  HE_Face f;
  ArrayList<HE_Vertex> vlist;
  while (fItr.hasNext ()) { 
    f = fItr.next(); 
    vlist = new ArrayList(f.getFaceVertices());
    if (vlist.size()==3) {
      //println(vlist.get(0).key()+","+vlist.get(1).key()+","+vlist.get(2).key());
      buffer.append("\t\t\t"+vertexKeys.get(vlist.get(0).key())+" "+vertexKeys.get(vlist.get(1).key())+" "+vertexKeys.get(vlist.get(2).key())+" -1\n");
    }
    vlist.clear();
    counter++;
  }
  //println(counter+" faces");

  buffer.append("\t\t] #coordIndex\n");

  buffer.append("\t\tcolorPerVertex FALSE\n");

  buffer.append("\t\tcolor Color {\n");
  buffer.append("\t\t\tcolor [\n");

  // list face colors
  counter = 0;
  fItr = myShape.fItr();
  while (fItr.hasNext ()) { 
    f = fItr.next(); 
    color c = colorMap.get(f.key());
    buffer.append("\t\t\t"+red(c)/255+" "+green(c)/255+" "+blue(c)/255+",\n");
    counter++;
  }
  //println(counter+" colors");

  buffer.append("\t\t\t] #color\n");
  buffer.append("\t\t} #Color\n");

  buffer.append("\t} #IndexedFaceSet\n");
  buffer.append("} #Shape\n");

  String[] output=new String[1];
  output[0] = buffer.toString();
  saveStrings(outputDirectory+"/" + name + ".wrl", output);
}

