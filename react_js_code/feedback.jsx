import React, { useState } from "react";

const FeedbackForm = () => {
  const [location, setLocation] = useState("");
  const [comfort, setComfort] = useState("");
  const [airQuality, setAirQuality] = useState("");

  const handleLocationChange = (event) => {
    setLocation(event.target.value);
  };

  const handleComfortChange = (event) => {
    setComfort(event.target.value);
  };

  const handleAirQualityChange = (event) => {
    setAirQuality(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    // Send feedback data to server
    console.log({ location, comfort, airQuality });
    // Reset form
    setLocation("");
    setComfort("");
    setAirQuality("");
  };

  return (
    <div>
      <h1>MERCE Office Feedback</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="location">Where are you located in the office now?</label>
          <select id="location" value={location} onChange={handleLocationChange}>
            <option value="">Select an option</option>
            <option value="meeting room">Meeting room</option>
            <option value="open office space">Open office space</option>
            <option value="pantry">Pantry</option>
          </select>
        </div>
        <div>
          <label htmlFor="comfort">How do you feel now?</label>
          <select id="comfort" value={comfort} onChange={handleComfortChange}>
            <option value="">Select an option</option>
            <option value="cool">Cool</option>
            <option value="neutral">Neutral</option>
            <option value="warm">Warm</option>
          </select>
        </div>
        <div>
          <label htmlFor="airQuality">How do you feel about the air quality?</label>
          <select id="airQuality" value={airQuality} onChange={handleAirQualityChange}>
            <option value="">Select an option</option>
            <option value="stuffy">Stuffy</option>
            <option value="good">Good</option>
          </select>
        </div>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default FeedbackForm;
