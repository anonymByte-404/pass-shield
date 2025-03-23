<h1 align="center">PassShield</h1>

<p>PassShield is a secure password manager that allows you to store, retrieve, and manage your passwords safely on your local machine. It uses strong encryption methods to protect your sensitive data.</p>

<h2>Features</h2>
<ul>
    <li><strong>Secure Password Storage:</strong> Encrypts passwords using AES-256 encryption.</li>
    <li><strong>Master Password Protection:</strong> Uses a master password to secure access to your stored passwords.</li>
    <li><strong>Local Storage:</strong> All data is stored locally in a secure directory, ensuring that only you have access to your passwords.</li>
    <li><strong>Add, Retrieve, and Remove Passwords:</strong> Easily manage your passwords with simple commands.</li>
</ul>

<h2>Requirements</h2>
<ul>
    <li>Ruby 3.1 or higher</li>
    <li>Required gems:
        <ul>
            <li><code>bcrypt</code></li>
            <li><code>openssl</code></li>
            <li><code>thor</code></li>
        </ul>
    </li>
</ul>

<h2>Installation</h2>
<ol>
    <li><strong>Clone the Repository:</strong>
        <pre><code>git clone https://github.com/anonymByte-404/pass-shield.git
cd pass-shield</code></pre>
    </li>
    <li><strong>Install Required Gems:</strong>
        <p>You can install the required gems using either of the following methods:</p>
        <h3>Option 1: Install Using Bundler</h3>
        <p>First, ensure you have Bundler installed:</p>
        <pre><code>gem install bundler</code></pre>
        <p>Then, run:</p>
        <pre><code>bundle install</code></pre>
        <h3>Option 2: Install Individually</h3>
        <p>Alternatively, you can install the required gems individually:</p>
        <pre><code>gem install bcrypt openssl thor</code></pre>
    </li>
    <li><strong>Setup Local Storage:</strong>
        <p>The application will create a local directory for storing your passwords when it runs for the first time:</p>
        <pre><code>ruby ./bin/pass_shield</code></pre>
    </li>
</ol>

<h2>Usage</h2>

<h3>Adding a Password</h3>
<p>To add a new password, use the following command:</p>
<pre><code>./bin/pass_shield add &lt;service&gt; &lt;username&gt;</code></pre>
<p>You will be prompted to enter your master password and the password you want to store.</p>

<h3>Retrieving a Password</h3>
<p>To retrieve a stored password, use the command:</p>
<pre><code>./bin/pass_shield get &lt;service&gt;</code></pre>
<p>You will need to enter your master password to access the password.</p>

<h3>Removing a Password</h3>
<p>To remove a stored password, use the command:</p>
<pre><code>./bin/pass_shield remove &lt;service&gt;</code></pre>
<p>You will be prompted to enter your master password for confirmation.</p>

<h2>Security</h2>
<p>All passwords are encrypted using AES-256 encryption, ensuring that your data is protected. The master password is required to access your stored passwords, and it should be kept confidential.</p>

<h2>Contribution</h2>
<p>Contributions are welcome! If you have suggestions for improvements or new features, feel free to create a pull request or open an issue.</p>

<h2>License</h2>
<p>This project is licensed under the MIT License. See the <a href="LICENSE">LICENSE</a> file for details.</p>