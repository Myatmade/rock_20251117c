import java.util.*;

Table tableData;
ArrayList<PasswordEntry> entries;
HashMap<String, ArrayList<PasswordEntry>> groups;
HashMap<String, ArrayList<PasswordEntry>> slicedGroups;   
ArrayList<String> patterns;
int current = 0;

Subplot subplot;

void setup() {
  size(900, 600);
  textFont(createFont("Arial", 12));

  entries = new ArrayList<PasswordEntry>();
  groups = new HashMap<String, ArrayList<PasswordEntry>>();
  slicedGroups = new HashMap<String, ArrayList<PasswordEntry>>();

  tableData = loadTable("4digitRockYouFrequencies_2kPlus.csv", "header");

  // Load data & classify 
  for (TableRow r : tableData.rows()) {
    String d = r.getString("digits");
    if (d == null) continue;
    if (d.length() < 4) d = ("0000" + d).substring(d.length());
    int f = r.getInt("frequency");

    PasswordEntry e = new PasswordEntry(d, f);
    e.pattern = detectPattern(d);
    entries.add(e);

    groups.putIfAbsent(e.pattern, new ArrayList<PasswordEntry>());
    groups.get(e.pattern).add(e);
  }

  // Sort pattern order
  ArrayList<String> raw = new ArrayList<String>(groups.keySet());
  Collections.sort(raw);

  patterns = new ArrayList<String>();
  String[] first = {"All Same", "Ascending Seq", "Descending Seq"};
  for (String f : first) if (raw.contains(f)) patterns.add(f);
  for (String p : raw) if (!patterns.contains(p)) patterns.add(p);

  for (String p : patterns) {
    Collections.sort(groups.get(p), (a,b)->a.digits.compareTo(b.digits));
  }

  // Split Other pattern into two subplots
  ArrayList<String> expanded = new ArrayList<String>();

  for (String p : patterns) {
    ArrayList<PasswordEntry> g = groups.get(p);

    if (p.equals("Other")) {
      ArrayList<PasswordEntry> part1 = new ArrayList<PasswordEntry>();
      ArrayList<PasswordEntry> part2 = new ArrayList<PasswordEntry>();

      for (PasswordEntry e : g) {
        int num = int(e.digits);
        if (num <= 5000) part1.add(e);
        else part2.add(e);
      }

      String p1 = "Other (0000–5000)";
      String p2 = "Other (5001–9999)";

      expanded.add(p1);
      expanded.add(p2);

      slicedGroups.put(p1, part1);
      slicedGroups.put(p2, part2);
    }
    else {
      expanded.add(p);
      slicedGroups.put(p, g);
    }
  }

  patterns = expanded;

  subplot = new Subplot(60, 40, width-120, height-120);
}

void draw() {
  background(255);

  // Main title
  fill(0);
  textAlign(CENTER, TOP);
  textSize(22);
  text("4-digit Passwords & Their Frequencies", width/2, 10);

  String pattern = patterns.get(current);
  subplot.group = slicedGroups.get(pattern);
  subplot.pattern = pattern;

  subplot.draw();

  // Hover hint
  fill(255,0,0);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("Hover on a point to see more details", width/2, height - 50);

  // Navigation text
  fill(255,0,0);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Press ← →   n/p to navigate   (" + (current+1) + "/" + patterns.size() + ")",
       width/2, height - 20);
}

void keyPressed() {
  if (keyCode == LEFT || key=='p' || key=='P') {
    current = max(0, current-1);
  } 
  else if (keyCode == RIGHT || key=='n' || key=='N') {
    current = min(patterns.size()-1, current+1);
  }
}

// Subplot class
class Subplot {
  int x, y, w, h;
  String pattern;
  ArrayList<PasswordEntry> group;

  Subplot(int x_, int y_, int w_, int h_) {
    x=x_; y=y_; w=w_; h=h_;
  }

  void draw() {
    pushStyle();

    fill(245);
    stroke(180);
    rect(x, y, w, h);

    // Subplot title
    fill(0);
    textAlign(CENTER, TOP);
    textSize(20);
    text(pattern + " (" + group.size() + " passwords)", x + w/2, y + 10);

    // Compute freq range
    int minF = Integer.MAX_VALUE;
    int maxF = Integer.MIN_VALUE;
    for (PasswordEntry e : group) {
      minF = min(minF, e.frequency);
      maxF = max(maxF, e.frequency);
    }
    if (minF == maxF) minF--;

    int px = x + 60;
    int py = y + 60;
    int pw = w - 110;
    int ph = h - 120;

    stroke(150);
    line(px, py, px, py+ph);
    line(px, py+ph, px+pw, py+ph);

    boolean small = isSmallGroup(pattern);
    int marginX = 20;

    // Hover detection
    PasswordEntry hoverEntry = null;
    float hoverX = 0, hoverY = 0;
    float minDist = 14;

    // Draw points
    strokeWeight(6);
    for (int i=0; i<group.size(); i++) {
      PasswordEntry e = group.get(i);

      float xp = map(i, 0, group.size()-1, px + marginX, px + pw - marginX);
      float yp = map(e.frequency, minF, maxF, py+ph-5, py+5);

      if (small) stroke(30,100,200);
      else stroke(30,100,200,90);

      point(xp, yp);

      float d = dist(mouseX, mouseY, xp, yp);
      if (d < minDist) {
        hoverEntry = e;
        hoverX = xp;
        hoverY = yp;
        minDist = d;
      }
    }

    // Top 5 highlight
    if (!small) {
      ArrayList<PasswordEntry> sorted = new ArrayList<PasswordEntry>(group);
      sorted.sort((a,b)->b.frequency - a.frequency);
      int top = min(5, sorted.size());

      stroke(200,20,20);
      strokeWeight(6);
      for (int i=0; i<top; i++) {
        PasswordEntry e = sorted.get(i);
        int idx = indexOfByDigits(group, e.digits);
        float xp = map(idx, 0, group.size()-1, px + marginX, px + pw - marginX);
        float yp = map(e.frequency, minF, maxF, py+ph-5, py+5);
        point(xp, yp);
      }

      fill(0);
      textSize(16);
      textAlign(LEFT, TOP);
      text("Top 5:", px+pw-60, py);
      for (int i=0; i<top; i++)
        text(sorted.get(i).digits, px+pw-50, py+18 + i*15);
    }

    // X labels
    textAlign(CENTER, TOP);
    textSize(16);
    int step = small ? 1 : max(1, group.size()/12);

    for (int i=0; i<group.size(); i+=step) {
      float xp = map(i, 0, group.size()-1, px + marginX, px + pw - marginX);

      pushMatrix();
      translate(xp, py+ph+18);
      rotate(-PI/4);
      fill(0);
      text(group.get(i).digits, 0, 0);
      popMatrix();
    }

    fill(0);
    textSize(16);
    textAlign(CENTER, TOP);
    text("Password (sorted)", px + pw/2, py + ph + 45);

    // Y labels
    fill(0);
    textSize(16);
    textAlign(RIGHT, CENTER);
    text(maxF, px - 6, py);
    text(minF, px - 6, py + ph);

    pushMatrix();
    translate(px - 40, py + ph/2);
    rotate(-PI/2);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Frequency", 0, 0);
    popMatrix();

    // Tooltip
    if (hoverEntry != null) {
      drawTooltip(hoverX, hoverY, hoverEntry);
    }

    popStyle();
  }

  void drawTooltip(float tx, float ty, PasswordEntry e) {
    pushStyle();
    textSize(16);

    String s1 = "PW: " + e.digits;
    String s2 = "Freq: " + e.frequency;

    float w = max(textWidth(s1), textWidth(s2)) + 18;
    float h = 40;

    float bx = tx + 14;
    float by = ty - 14;

    fill(255, 245);
    stroke(120);
    strokeWeight(1);
    rect(bx, by, w, h, 6);

    fill(0);
    textAlign(LEFT, TOP);
    text(s1, bx+8, by+6);
    text(s2, bx+8, by+22);

    popStyle();
  }

  boolean isSmallGroup(String p) {
    return p.contains("All Same") || p.contains("Ascending Seq") || p.contains("Descending Seq");
  }
}

// Helpers
String detectPattern(String p) {
  char A=p.charAt(0), B=p.charAt(1), C=p.charAt(2), D=p.charAt(3);

  if (A==B && B==C && C==D) return "All Same";
  if (p.equals(new StringBuilder(p).reverse().toString())) return "Palindrome";
  if (A==B && C==D) return "AABB";
  if (A==C && B==D) return "ABAB";

  String[] asc={"0123","1234","2345","3456","4567","5678","6789"};
  for (String s:asc) if (p.equals(s)) return "Ascending Seq";

  String[] desc={"9876","8765","7654","6543","5432","4321","3210"};
  for (String s:desc) if (p.equals(s)) return "Descending Seq";

  if (p.startsWith("19") || p.startsWith("20")) return "Year-like";

  return "Other";
}

int indexOfByDigits(ArrayList<PasswordEntry> list, String d) {
  for (int i=0; i<list.size(); i++)
    if (list.get(i).digits.equals(d)) return i;
  return -1;
}

class PasswordEntry {
  String digits;
  int frequency;
  String pattern;
  PasswordEntry(String d, int f) { digits=d; frequency=f; }
}
