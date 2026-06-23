export default function App() {
  return (
    <div className="app-container">
      <header>
        <h1>React App Hosted on S3 + CloudFront</h1>
        <p>This is a minimal demo application.</p>
      </header>
      <section>
        <ul>
          <li>Static files stored in S3</li>
          <li>CloudFront delivers the site globally</li>
          <li>Single-page app routing enabled via error responses</li>
        </ul>
      </section>
    </div>
  )
}
