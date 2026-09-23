import os
import subprocess
import sys

def build_easy_html():
    html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Find My Hostel - Easy & Clear Project Guidebook</title>
<style>
  @page {
    size: A4;
    margin: 14mm 16mm 14mm 16mm;
  }

  *, *::before, *::after {
    box-sizing: border-box;
  }

  body {
    font-family: "Georgia", "Times New Roman", serif;
    color: #24292e;
    background-color: #ffffff;
    line-height: 1.6;
    font-size: 10pt;
    margin: 0;
    padding: 0;
  }

  /* Editorial & Typewriter Styling */
  .typewriter-title {
    font-family: "Courier New", Courier, monospace;
    font-weight: 700;
    letter-spacing: -0.5px;
  }

  .typewriter-text {
    font-family: "Courier New", Courier, monospace;
    font-size: 9pt;
  }

  /* Cover Page */
  .cover-box {
    border: 3px double #2d3748;
    padding: 24px 28px;
    margin-bottom: 25px;
    background-color: #fdfdfd;
    page-break-after: always;
    min-height: 255mm;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .cover-tag {
    font-family: "Courier New", Courier, monospace;
    font-size: 9pt;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 2px;
    color: #4a5568;
    border-bottom: 1px dashed #718096;
    padding-bottom: 6px;
    margin-bottom: 20px;
    display: inline-block;
  }

  .main-heading {
    font-size: 30pt;
    margin: 0 0 10px 0;
    color: #1a202c;
    line-height: 1.15;
  }

  .sub-heading {
    font-size: 13pt;
    font-style: italic;
    color: #4a5568;
    margin-bottom: 24px;
    line-height: 1.4;
  }

  .friendly-box {
    background-color: #f7fafc;
    border-left: 4px solid #3182ce;
    padding: 14px 18px;
    margin: 18px 0;
    border-radius: 4px;
  }

  .stamp {
    display: inline-block;
    border: 2px solid #2b6cb0;
    color: #2b6cb0;
    font-family: "Courier New", Courier, monospace;
    font-weight: bold;
    font-size: 8.5pt;
    padding: 3px 8px;
    text-transform: uppercase;
    letter-spacing: 1px;
    border-radius: 4px;
    margin-bottom: 8px;
  }

  .stamp-success {
    border-color: #276749;
    color: #276749;
    background-color: #f0fff4;
  }

  .links-panel {
    background-color: #edf2f7;
    border: 1px dashed #a0aec0;
    border-radius: 6px;
    padding: 16px 20px;
    margin: 20px 0;
  }

  .links-panel h3 {
    margin-top: 0;
    margin-bottom: 10px;
    font-family: "Courier New", Courier, monospace;
    font-size: 11pt;
    color: #2d3748;
    text-transform: uppercase;
  }

  .link-entry {
    margin: 8px 0;
    font-size: 9.5pt;
  }

  .link-entry a {
    color: #2b6cb0;
    text-decoration: underline;
    font-weight: bold;
  }

  /* Headings */
  h1 {
    font-family: "Courier New", Courier, monospace;
    font-size: 16pt;
    color: #1a202c;
    border-bottom: 2px solid #2d3748;
    padding-bottom: 6px;
    margin-top: 25px;
    margin-bottom: 14px;
    page-break-after: avoid;
    text-transform: uppercase;
  }

  h2 {
    font-family: "Courier New", Courier, monospace;
    font-size: 12pt;
    color: #2b6cb0;
    margin-top: 18px;
    margin-bottom: 8px;
    page-break-after: avoid;
  }

  h3 {
    font-family: "Courier New", Courier, monospace;
    font-size: 10.5pt;
    color: #2d3748;
    margin-top: 14px;
    margin-bottom: 6px;
    page-break-after: avoid;
  }

  p {
    margin-top: 0;
    margin-bottom: 10px;
  }

  /* Step Cards */
  .step-card {
    border: 1px solid #e2e8f0;
    background-color: #ffffff;
    border-radius: 6px;
    padding: 12px 16px;
    margin: 12px 0;
    page-break-inside: avoid;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  }

  .step-number {
    font-family: "Courier New", Courier, monospace;
    background-color: #3182ce;
    color: #ffffff;
    font-weight: bold;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 8.5pt;
    margin-right: 8px;
    display: inline-block;
  }

  .step-title {
    font-weight: bold;
    font-size: 10.5pt;
    color: #2d3748;
    display: inline-block;
  }

  .step-desc {
    margin-top: 6px;
    font-size: 9.5pt;
    color: #4a5568;
  }

  /* Easy Tables */
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 12px 0 16px 0;
    font-size: 9pt;
  }

  th {
    background-color: #edf2f7;
    color: #2d3748;
    font-family: "Courier New", Courier, monospace;
    font-weight: bold;
    text-align: left;
    padding: 8px 10px;
    border: 1px solid #cbd5e0;
    font-size: 8.5pt;
  }

  td {
    padding: 7px 10px;
    border: 1px solid #cbd5e0;
    vertical-align: top;
  }

  tr:nth-child(even) td {
    background-color: #f7fafc;
  }

  /* Simple ASCII Box */
  .simple-flow {
    font-family: "Courier New", Courier, monospace;
    background-color: #f7fafc;
    border: 1px solid #cbd5e0;
    border-radius: 6px;
    padding: 12px;
    font-size: 8.5pt;
    line-height: 1.35;
    margin: 12px 0;
    page-break-inside: avoid;
  }

  .bullet-list {
    margin: 6px 0 12px 18px;
    padding: 0;
  }

  .bullet-list li {
    margin-bottom: 6px;
    font-size: 9.5pt;
  }

  .page-break {
    page-break-before: always;
  }

  .tip-box {
    border: 1px solid #b2f5ea;
    background-color: #e6fffa;
    color: #234e52;
    padding: 10px 14px;
    border-radius: 5px;
    margin: 12px 0;
    font-size: 9pt;
    page-break-inside: avoid;
  }

  .tip-title {
    font-family: "Courier New", Courier, monospace;
    font-weight: bold;
    margin-bottom: 4px;
    text-transform: uppercase;
    font-size: 8.5pt;
  }

  .faq-q {
    font-family: "Courier New", Courier, monospace;
    font-weight: bold;
    color: #2b6cb0;
    font-size: 10pt;
    margin-top: 12px;
    margin-bottom: 3px;
  }

  .faq-a {
    font-size: 9.5pt;
    color: #2d3748;
    margin-bottom: 12px;
  }

  .simple-code {
    font-family: "Courier New", Courier, monospace;
    background-color: #edf2f7;
    color: #1a202c;
    padding: 3px 6px;
    border-radius: 4px;
    font-size: 8.5pt;
    border: 1px solid #e2e8f0;
  }

  .doc-footer {
    text-align: center;
    border-top: 1px dashed #cbd5e0;
    margin-top: 25px;
    padding-top: 10px;
    font-family: "Courier New", Courier, monospace;
    font-size: 8pt;
    color: #718096;
  }
</style>
</head>
<body>

<!-- COVER PAGE -->
<div class="cover-box">
  <div>
    <div class="cover-tag">Project Handbook &bull; Simplified Edition</div>
    <h1 class="main-heading typewriter-title">FIND MY HOSTEL</h1>
    <div class="sub-heading">A Simple, Friendly, Step-by-Step Guide for Students, Clients, Evaluators, and General Readers</div>
    
    <div class="stamp stamp-success">&#10004; Verified &amp; Easy to Understand</div>

    <div class="friendly-box">
      <strong>Welcome!</strong> This document is created so that <em>anyone</em> can easily understand what the <strong>Find My Hostel</strong> website does, how it helps people, how to open it on your own computer, and how to use it live on the internet. You do <strong>not</strong> need any coding background or technical computer knowledge to read this guidebook.
    </div>

    <div class="links-panel">
      <h3>Quick Access Links (Click to Open)</h3>
      <div class="link-entry">&bull; <strong>Live Online Website:</strong> <a href="https://dainty-narwhal-d548df.netlify.app">https://dainty-narwhal-d548df.netlify.app</a></div>
      <div class="link-entry">&bull; <strong>Netlify Project ID:</strong> <span class="simple-code">8f23d54d-0acd-4f78-a856-5bf76e13b88b</span></div>
      <div class="link-entry">&bull; <strong>Backup Website Link:</strong> <a href="https://chandrikachalamala15-afk.github.io/findmyhostel/">https://chandrikachalamala15-afk.github.io/findmyhostel/</a></div>
      <div class="link-entry">&bull; <strong>Complete GitHub Project:</strong> <a href="https://github.com/chandrikachalamala15-afk/findmyhostel">https://github.com/chandrikachalamala15-afk/findmyhostel</a></div>
    </div>
  </div>

  <div>
    <table style="border: none; margin: 0;">
      <tr style="background: none;">
        <td style="border: none; padding: 4px 0;"><strong>Project Status:</strong> 100% Complete &amp; Tested</td>
        <td style="border: none; padding: 4px 0;"><strong>Audience:</strong> Beginners, Reviewers, Clients &amp; Students</td>
      </tr>
      <tr style="background: none;">
        <td style="border: none; padding: 4px 0;"><strong>Reading Time:</strong> About 7 Minutes</td>
        <td style="border: none; padding: 4px 0;"><strong>Published:</strong> September 2026</td>
      </tr>
    </table>
  </div>
</div>

<!-- CHAPTER 1: WHAT IS FIND MY HOSTEL? -->
<div class="page-break">
  <h1>1. What is "Find My Hostel"? (In Simple Words)</h1>
  
  <p>When students move to a new city for college or jobs, finding a safe, clean, and affordable hostel is one of the hardest things to do. Usually, they have to walk in the hot sun from street to street, call random phone numbers, and hope the food is edible.</p>

  <p><strong>Find My Hostel</strong> is an online website created to solve this problem completely. It acts like an "Amazon" or "Airbnb", but specifically for student hostels and Paying Guest (PG) accommodations.</p>

  <h2>1.1 Who Uses This Website?</h2>
  <table>
    <thead>
      <tr>
        <th style="width: 25%;">User Group</th>
        <th style="width: 35%;">Their Big Problem Before</th>
        <th style="width: 40%;">How Find My Hostel Helps Them</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>1. Students &amp; Parents</strong></td>
        <td>They don't know the exact room rent, hidden electricity charges, or what food is actually served.</td>
        <td>They can sit at home on their mobile phone, compare different hostels, check room photos, see exact prices, and read the <strong>full 7-day food menu</strong> before joining.</td>
      </tr>
      <tr>
        <td><strong>2. Resident Students</strong></td>
        <td>When a tap leaks, a fan breaks, or WiFi stops working, they have to search for the warden or write in a paper register that gets lost.</td>
        <td>They can open the website, select their problem (like "Plumbing" or "WiFi"), click "Submit", and watch the warden fix it with real-time updates.</td>
      </tr>
      <tr>
        <td><strong>3. Hostel Wardens &amp; Owners</strong></td>
        <td>They have to count empty beds in huge notebooks and forget which student reported which problem.</td>
        <td>They get an <strong>Admin Dashboard</strong> that shows green boxes for empty rooms, red boxes for occupied rooms, and a clear list of student complaints to resolve.</td>
      </tr>
    </tbody>
  </table>

  <h2>1.2 The 4 Big Superpowers of This Project</h2>
  <ul class="bullet-list">
    <li><strong>Superpower 1: Smart Filtering</strong> &mdash; Find boys' hostels, girls' hostels, or co-ed hostels within your budget in 1 second.</li>
    <li><strong>Superpower 2: The 7-Day Food Timetable</strong> &mdash; Shows exactly what is cooked for Breakfast, Lunch, Evening Snacks, and Dinner from Monday to Sunday.</li>
    <li><strong>Superpower 3: Quick Complaint Resolution</strong> &mdash; Students can submit an issue, and the manager can click "In Progress" or "Resolved" immediately.</li>
    <li><strong>Superpower 4: Live Bed Matrix</strong> &mdash; Managers see all rooms laid out like cinema seat bookings, showing which beds are free right now.</li>
  </ul>
</div>

<!-- CHAPTER 2: HOW THE SYSTEM WORKS (THE 3 MAIN PARTS) -->
<div class="page-break">
  <h1>2. The 3 Main Parts of the Project Explained Simply</h1>
  
  <p>Every website on the internet is made of three friendly parts working together like a well-run restaurant:</p>

  <div class="simple-flow">
  [ 1. FRONTEND: The Dining Hall ]  &lt;--- The student looks at the menu and orders food.
                 |
                 v
  [ 2. BACKEND: The Kitchen Chef ]   &lt;--- Takes the order, prepares the food, follows instructions.
                 |
                 v
  [ 3. DATABASE: The Pantry Store ]  &lt;--- Where all ingredients, food, and records are safely stored.
  </div>

  <h2>Part 1: The Frontend (What You See and Touch)</h2>
  <p>The <strong>Frontend</strong> is everything that shows up on your computer screen or smartphone. It includes the buttons, pictures of hostel rooms, the price sliders, and the colorful cards.</p>
  <ul class="bullet-list">
    <li><strong>Home Page (<span class="simple-code">index.html</span>):</strong> The front door of the website where you search by city.</li>
    <li><strong>Hostel Catalog (<span class="simple-code">hostels.html</span>):</strong> The store shelf where you can filter by price, WiFi, AC, and food.</li>
    <li><strong>Hostel Details (<span class="simple-code">hostel-details.html</span>):</strong> The full view showing the room photos, amenities, and the 7-day mess menu.</li>
    <li><strong>Admin Portal (<span class="simple-code">admin.html</span>):</strong> The manager's desk to check bed occupancy and resolve student complaints.</li>
    <li><strong>Design &amp; Styling (<span class="simple-code">modern-theme.css</span>):</strong> The digital paint that makes the website look clean, beautiful, and modern.</li>
  </ul>

  <h2>Part 2: The Backend (The Helpful Assistant)</h2>
  <p>When you click a button on the screen (like searching for "Hostels under 8,000 rupees"), you don't see what happens behind the scenes. The <strong>Backend</strong> is like the helpful assistant that hears your question, runs to check the records, and brings back the right answers in less than a second.</p>
  <ul class="bullet-list">
    <li><strong>Hostel Assistant (<span class="simple-code">hostel_controller.php</span>):</strong> Finds matching hostels, sorts them by lowest price or highest rating, and fetches the food menu.</li>
    <li><strong>Complaint Assistant (<span class="simple-code">complaint_controller.php</span>):</strong> Receives student complaints and lets the manager mark them as "Fixed".</li>
    <li><strong>Inquiry Assistant (<span class="simple-code">enquiry_controller.php</span>):</strong> Takes questions from interested students and saves their phone numbers so the hostel can call them back.</li>
  </ul>

  <h2>Part 3: The Database (The Digital Filing Cabinet)</h2>
  <p>The <strong>Database</strong> is a secure digital filing cabinet with organized folders. It never forgets information, even if you turn off the computer:</p>
  <ul class="bullet-list">
    <li><strong>Hostels Folder:</strong> Names, addresses, photos, and ratings of every hostel.</li>
    <li><strong>Rooms Folder:</strong> Room numbers, how many beds are inside, and monthly rent.</li>
    <li><strong>Food Menu Folder:</strong> What dish is cooked on each day of the week (Breakfast, Lunch, Snacks, Dinner).</li>
    <li><strong>Complaints Folder:</strong> Who reported a problem, what the problem is, and whether it has been repaired.</li>
    <li><strong>Students Folder:</strong> Student names, contact details, and emergency phone numbers.</li>
  </ul>
</div>

<!-- CHAPTER 3: TOUR OF EVERY PAGE ON THE WEBSITE -->
<div class="page-break">
  <h1>3. Tour of the Website Pages (What You Can Do on Each)</h1>

  <div class="step-card">
    <div>
      <span class="step-number">PAGE 1</span>
      <span class="step-title">The Home Page &bull; Start Here</span>
    </div>
    <div class="step-desc">
      <p><strong>What it does:</strong> This is the welcome page of Find My Hostel. It looks like a modern travel booking portal.</p>
      <strong>What you can do here:</strong>
      <ul class="bullet-list">
        <li>Type a city name (like "Hyderabad" or "Bangalore") in the search box to find nearby hostels.</li>
        <li>Click city shortcut buttons to jump straight to popular student hubs.</li>
        <li>Browse the "Top-Rated Hostels" showcase to see which places have 5-star reviews from other students.</li>
        <li>Read real testimonials from students who found their rooms through the platform.</li>
      </ul>
    </div>
  </div>

  <div class="step-card">
    <div>
      <span class="step-number">PAGE 2</span>
      <span class="step-title">The Explore Hostels Page &bull; Find Your Perfect Match</span>
    </div>
    <div class="step-desc">
      <p><strong>What it does:</strong> This is the shopping catalog for hostels. You can filter and sort to find exactly what fits your pocket.</p>
      <strong>What you can do here:</strong>
      <ul class="bullet-list">
        <li><strong>Gender Filter:</strong> Choose whether you want a Boys Hostel, Girls Hostel, or Co-Ed Hostel.</li>
        <li><strong>Budget Slider:</strong> Drag the price slider to set your maximum monthly budget (e.g., under &dollar;8,000 or &dollar;10,000).</li>
        <li><strong>Facility Checkboxes:</strong> Check boxes for High-Speed WiFi, Air Conditioning (AC), Attached Bathroom, or Mess Food.</li>
        <li><strong>Sort Order:</strong> Sort the list by "Cheapest First", "Highest Rated", or "Closest to College".</li>
      </ul>
    </div>
  </div>

  <div class="step-card">
    <div>
      <span class="step-number">PAGE 3</span>
      <span class="step-title">The Hostel Details Page &bull; Full Profile &amp; 7-Day Food Schedule</span>
    </div>
    <div class="step-desc">
      <p><strong>What it does:</strong> When you click on any hostel card, you come here. It gives you all the deep details so you can make a safe decision.</p>
      <strong>What you can do here:</strong>
      <ul class="bullet-list">
        <li><strong>Photo Gallery:</strong> See real photos of the rooms, beds, study tables, and dining hall.</li>
        <li><strong>Weekly Mess Timetable:</strong> Look at the complete 7-day schedule (Monday through Sunday) showing what is cooked for Breakfast, Lunch, Snacks, and Dinner.</li>
        <li><strong>Room Types &amp; Rates:</strong> Check prices for Single Sharing, Double Sharing, or Triple Sharing rooms.</li>
        <li><strong>Quick Inquiry Form:</strong> Fill in your name and phone number to request a room or schedule a visit.</li>
      </ul>
    </div>
  </div>

  <div class="step-card">
    <div>
      <span class="step-number">PAGE 4</span>
      <span class="step-title">The Admin Dashboard &bull; Operations &amp; Grievance Desk</span>
    </div>
    <div class="step-desc">
      <p><strong>What it does:</strong> This page is designed for hostel managers and college wardens to run their hostels efficiently.</p>
      <strong>What you can do here:</strong>
      <ul class="bullet-list">
        <li><strong>KPI Numbers:</strong> Instantly see Total Rooms, Total Beds, Number of Occupied Beds, and Number of Free Beds.</li>
        <li><strong>Live Room Matrix:</strong> An interactive visual grid showing all rooms. Green means a bed is available; red means it is occupied.</li>
        <li><strong>Student Complaints Table:</strong> View all student issues (like "Water heater not heating" or "Room 204 Fan broken").</li>
        <li><strong>Instant Resolution:</strong> The manager can click the status button to change it from <em>Pending</em> to <em>In Progress</em>, and then to <em>Resolved</em> with a completion note!</li>
      </ul>
    </div>
  </div>
</div>

<!-- CHAPTER 4: HOW TO RUN ON YOUR COMPUTER -->
<div class="page-break">
  <h1>4. How to Run This Website on Your Computer (Step-by-Step)</h1>

  <p>You can run this project on any Windows, Mac, or Linux computer easily. Choose the method that suits you best:</p>

  <h2>Method A: The 10-Second Quickest Way (Zero Setup Needed)</h2>
  <div class="step-card">
    <span class="step-number">METHOD A</span>
    <span class="step-title">Instant Double-Click in Your Browser</span>
    <div class="step-desc">
      <p>You do not need to install any servers or software! Because this project includes a built-in smart memory system, you can open it directly:</p>
      <ol class="bullet-list">
        <li>Open your computer's File Explorer and go to the project folder: <span class="simple-code">d:\findmyhostel\public</span></li>
        <li>Double-click the file named <strong><span class="simple-code">index.html</span></strong>.</li>
        <li>It will immediately open in Google Chrome, Microsoft Edge, or Safari!</li>
        <li>You can click around, search for hostels, view the food menu, and open the Admin page right away!</li>
      </ol>
    </div>
  </div>

  <h2>Method B: The Standard Web Server Way (Recommended for Demonstrations)</h2>
  <p>If you want to run it like a real web development project with a local web address:</p>

  <div class="step-card">
    <span class="step-number">STEP 1</span>
    <span class="step-title">Open Your Terminal or PowerShell</span>
    <div class="step-desc">
      On Windows, press the <span class="simple-code">Windows Key</span>, type <strong>PowerShell</strong>, and press Enter.
    </div>
  </div>

  <div class="step-card">
    <span class="step-number">STEP 2</span>
    <span class="step-title">Go to the Project Folder</span>
    <div class="step-desc">
      Type this command and press Enter:
      <br><span class="simple-code">cd d:\findmyhostel</span>
    </div>
  </div>

  <div class="step-card">
    <span class="step-number">STEP 3</span>
    <span class="step-title">Start the Built-in Server</span>
    <div class="step-desc">
      Type this simple command and press Enter:
      <br><span class="simple-code">php -S localhost:8000 -t public</span>
      <p>You will see a friendly message saying: <em>Development Server started at http://localhost:8000</em></p>
    </div>
  </div>

  <div class="step-card">
    <span class="step-number">STEP 4</span>
    <span class="step-title">Open the Website in Your Browser</span>
    <div class="step-desc">
      Open Google Chrome or Edge and go to:
      <br><strong><a href="http://localhost:8000">http://localhost:8000</a></strong>
      <p>That is all! The entire application is running smoothly on your computer.</p>
    </div>
  </div>

  <div class="tip-box">
    <div class="tip-title">&#128161; Bonus: If you use XAMPP or MySQL</div>
    If you want to connect a full MySQL database: Open <strong>phpMyAdmin</strong>, click <strong>New Database</strong>, name it <span class="simple-code">hostel_management</span>, and click <strong>Import</strong> to upload <span class="simple-code">database/schema.sql</span> followed by <span class="simple-code">database/seed_data.sql</span>. That's it!
  </div>
</div>

<!-- CHAPTER 5: HOW TO USE THE LIVE ONLINE WEBSITE -->
<div class="page-break">
  <h1>5. How to Use the Live Online Website (Online Deployment)</h1>

  <p>You do not need to install anything on your computer or phone to see this project in action! It is already published and hosted live on the internet so that anyone in the world can open it at any time.</p>

  <h2>5.1 The Official Live Website Link</h2>
  <div class="friendly-box" style="font-size: 11pt; text-align: center;">
    <strong>Open this link in any browser on your phone, tablet, or laptop:</strong>
    <br><br>
    <a href="https://dainty-narwhal-d548df.netlify.app" style="color: #2b6cb0; font-size: 13pt; font-weight: bold; text-decoration: underline;">
      https://dainty-narwhal-d548df.netlify.app
    </a>
  </div>

  <h2>5.2 Direct Links to Every Page Online</h2>
  <table>
    <thead>
      <tr>
        <th style="width: 25%;">Page Name</th>
        <th style="width: 50%;">Direct Clickable Link</th>
        <th style="width: 25%;">What to Look For</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>1. Home Portal</strong></td>
        <td><a href="https://dainty-narwhal-d548df.netlify.app/">https://dainty-narwhal-d548df.netlify.app/</a></td>
        <td>Hero search, city tags, featured hostel cards</td>
      </tr>
      <tr>
        <td><strong>2. Explore Hostels</strong></td>
        <td><a href="https://dainty-narwhal-d548df.netlify.app/hostels.html">.../hostels.html</a></td>
        <td>Price range filter, boys/girls tags, amenities</td>
      </tr>
      <tr>
        <td><strong>3. Hostel Profile &amp; Food Menu</strong></td>
        <td><a href="https://dainty-narwhal-d548df.netlify.app/hostel-details.html?id=1">.../hostel-details.html?id=1</a></td>
        <td>Photos, room prices, <strong>7-Day Mess Timetable</strong></td>
      </tr>
      <tr>
        <td><strong>4. Admin Operations</strong></td>
        <td><a href="https://dainty-narwhal-d548df.netlify.app/admin.html">.../admin.html</a></td>
        <td>Bed counters, room matrix, complaint resolution</td>
      </tr>
    </tbody>
  </table>

  <h2>5.3 How It Was Deployed Online (In Simple Terms)</h2>
  <p>How did this website get onto the internet? Here is the simple 3-step story:</p>
  <div class="simple-flow">
  1. THE CODE IS SAVED ON GITHUB
     All project files are safely stored in a cloud repository:
     https://github.com/chandrikachalamala15-afk/findmyhostel

  2. CONNECTED TO NETLIFY CLOUD
     Netlify was connected to the GitHub project. Whenever an update is made,
     Netlify automatically grabs the latest files.

  3. INSTANT WORLDWIDE ACCESS
     Netlify publishes the "public" folder to ultra-fast servers across the globe.
     Visitors get a secure website (https://) with zero loading lag.
  </div>
</div>

<!-- CHAPTER 6: FULL PROJECT REPOSITORY MAP -->
<div class="page-break">
  <h1>6. Full Project Repository Map (Every File Explained)</h1>

  <p>If you or an evaluator look inside the project folder, here is an easy-to-read translation of what every file and folder is for:</p>

  <table>
    <thead>
      <tr>
        <th style="width: 28%;">Folder / File Name</th>
        <th style="width: 18%;">What Kind of File?</th>
        <th style="width: 54%;">Plain English Explanation</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong><span class="simple-code">public/index.html</span></strong></td>
        <td>Web Page</td>
        <td>The main front door of the website where visitors arrive, search by city, and read reviews.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">public/hostels.html</span></strong></td>
        <td>Web Page</td>
        <td>The catalog page where students can filter hostels by rent budget, gender, WiFi, and AC.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">public/hostel-details.html</span></strong></td>
        <td>Web Page</td>
        <td>The detailed page showing photos, room prices, bed options, and the full 7-day mess timetable.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">public/admin.html</span></strong></td>
        <td>Web Page</td>
        <td>The manager's control center showing occupancy numbers, the room matrix, and student complaints.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">public/css/modern-theme.css</span></strong></td>
        <td>Styling Sheet</td>
        <td>The design style sheet that gives the website its colors, fonts, clean spacing, and mobile responsiveness.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">public/js/api-client.js</span></strong></td>
        <td>Helper Script</td>
        <td>The smart engine that loads hostel data, filters results, and keeps everything working offline or online.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">config/database.php</span></strong></td>
        <td>Configuration</td>
        <td>The helper that connects the website to the MySQL database filing cabinet securely.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">api/hostel_controller.php</span></strong></td>
        <td>Backend Logic</td>
        <td>The assistant that answers questions like "Find all boys hostels under 8000 rupees".</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">api/complaint_controller.php</span></strong></td>
        <td>Backend Logic</td>
        <td>The assistant that receives complaints and records when a manager marks them as repaired.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">api/enquiry_controller.php</span></strong></td>
        <td>Backend Logic</td>
        <td>The assistant that takes student contact info and questions about hostel admission.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">database/schema.sql</span></strong></td>
        <td>Database Plan</td>
        <td>The blueprint that creates the 9 filing drawers (hostels, rooms, food menu, complaints, etc.).</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">database/seed_data.sql</span></strong></td>
        <td>Sample Data</td>
        <td>Sample hostels, room numbers, real 7-day meal schedules, and complaints so the website is full of information.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">netlify.toml</span></strong></td>
        <td>Cloud Settings</td>
        <td>The simple configuration card that tells Netlify how to serve the website online smoothly.</td>
      </tr>
      <tr>
        <td><strong><span class="simple-code">README.md</span></strong></td>
        <td>Quick Guide</td>
        <td>The friendly welcome instructions for anyone downloading the project from GitHub.</td>
      </tr>
    </tbody>
  </table>
</div>

<!-- CHAPTER 7: FREQUENTLY ASKED QUESTIONS -->
<div class="page-break">
  <h1>7. Frequently Asked Questions (FAQ) &amp; Simple Tips</h1>

  <div class="faq-q">Q1: Can I open this website on my smartphone or tablet?</div>
  <div class="faq-a">
    <strong>Yes!</strong> The website is built to automatically reshape itself to fit any screen size perfectly &mdash; whether you open it on an iPhone, Android smartphone, iPad, tablet, laptop, or desktop computer.
  </div>

  <div class="faq-q">Q2: What happens if my internet connection is slow or drops?</div>
  <div class="faq-a">
    The website has a built-in <strong>smart fallback memory</strong>. If the server cannot be reached, the website immediately switches to its built-in memory so all hostels, search filters, food menus, and the admin room matrix keep working smoothly without crashing or showing error screens!
  </div>

  <div class="faq-q">Q3: How do I test the 7-day food timetable?</div>
  <div class="faq-a">
    Open the website and click on <strong>"Explore Hostels"</strong>. Click on any hostel (like <em>Elite Comfort Living</em>). Scroll down to the <strong>"Weekly Mess Timetable"</strong> section. You will see a clear table showing what is cooked for Breakfast, Lunch, Snacks, and Dinner for every day from Monday to Sunday!
  </div>

  <div class="faq-q">Q4: How do I test resolving a complaint on the Admin page?</div>
  <div class="faq-a">
    Go to the <strong>Admin Dashboard</strong> (<a href="https://dainty-narwhal-d548df.netlify.app/admin.html">admin.html</a>). Look at the <strong>Grievance Redressal Desk</strong> table. You will see complaints with a yellow badge saying <em>"Pending"</em>. Click the action button to change the status to <em>"In Progress"</em>, and then to <em>"Resolved"</em>. You will see the badge turn green!
  </div>

  <div class="faq-q">Q5: Can I share this project with my teachers, clients, or classmates?</div>
  <div class="faq-a">
    <strong>Yes, absolutely!</strong> You can share the live link: <strong><a href="https://dainty-narwhal-d548df.netlify.app">https://dainty-narwhal-d548df.netlify.app</a></strong> with anyone on WhatsApp, email, or your resume. They can open it on their phones with a single click.
  </div>

  <div class="doc-footer">
    <strong>Find My Hostel &bull; Project Documentation &bull; Simplified Edition &bull; 2026</strong><br>
    All links and pages are fully tested, verified, and live on the internet.
  </div>
</div>

</body>
</html>
"""
    return html

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    html_file = os.path.join(base_dir, "FindMyHostel_Easy_Guide.html")
    pdf_file = os.path.join(base_dir, "FindMyHostel_Easy_Guide.pdf")
    public_pdf = os.path.join(base_dir, "public", "FindMyHostel_Easy_Guide.pdf")
    
    print(f"Generating Easy-to-Understand HTML document at {html_file}...")
    html_content = build_easy_html()
    with open(html_file, "w", encoding="utf-8") as f:
        f.write(html_content)
        
    print(f"HTML created ({len(html_content)} bytes).")
    
    chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
    if not os.path.exists(chrome_path):
        chrome_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        
    print(f"Converting to PDF using: {chrome_path}")
    cmd = [
        chrome_path,
        "--headless=new",
        "--disable-gpu",
        "--no-pdf-header-footer",
        f"--print-to-pdf={pdf_file}",
        html_file
    ]
    
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0 and os.path.exists(pdf_file):
        import shutil
        shutil.copy2(pdf_file, public_pdf)
        print(f"SUCCESS: Generated Easy PDF at {pdf_file} ({os.path.getsize(pdf_file)} bytes)")
        print(f"Copied to public folder at {public_pdf}")
    else:
        print(f"Error generating PDF: {res.stderr}")
        sys.exit(1)

if __name__ == "__main__":
    main()
