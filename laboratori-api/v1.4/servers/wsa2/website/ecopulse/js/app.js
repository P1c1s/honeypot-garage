const cityInput = document.getElementById('city');
const cityList = document.getElementById('city-list');

// Gli elementi meteo (uguali)
const tempEl = document.getElementById('temp');
const feelsLikeEl = document.getElementById('feels-like');
const airQualityEl = document.getElementById('air-quality');
const humidityEl = document.getElementById('humidity');
const uvIndexEl = document.getElementById('uv-index');
const windSpeedEl = document.getElementById('wind-speed');
const windDirectionEl = document.getElementById('wind-direction');
const pressureEl = document.getElementById('pressure');
const rainChanceEl = document.getElementById('rain-chance');
const visibilityEl = document.getElementById('visibility');
const sunriseEl = document.getElementById('sunrise');
const sunsetEl = document.getElementById('sunset');
const mainPollutantsEl = document.getElementById('main-pollutants');
const disasterListEl = document.getElementById('disaster-list');
const pollenEl = document.getElementById('pollen');

let cities = {};

const pollenData = {
  milano: 'Moderato (graminacee, betulla)',
  roma: 'Basso (parietaria)',
  napoli: 'Alto (olivo, cipresso)',
  torino: 'Moderato (betulla, quercia)',
  firenze: 'Basso (graminacee)',
};

function mapAQI(aqi) {
  const labels = {
    1: 'Buona',
    2: 'Moderata',
    3: 'Scarsa',
    4: 'Pessima',
    5: 'Molto pessima'
  };
  return labels[aqi] || 'N/D';
}

function mpsToKmh(mps) {
  return (mps * 3.6).toFixed(1);
}

function formatPollutants(components) {
  const pollutantNames = {
    co: 'CO',
    no: 'NO',
    no2: 'NO₂',
    o3: 'O₃',
    so2: 'SO₂',
    pm2_5: 'PM2.5',
    pm10: 'PM10',
    nh3: 'NH₃',
  };

  return Object.entries(components)
    .filter(([_, val]) => val > 0)
    .map(([key, val]) => `${pollutantNames[key]}: ${val.toFixed(2)} µg/m³`)
    .join(', ') || '--';
}

function updatePollen(city) {
  const key = city.toLowerCase();
  pollenEl.textContent = pollenData[key] || '--';
}

async function fetchWeatherAndAir(lat, lon) {
  const API_KEY = '8d2a751ccdf85468f6965805f3b51243';

  const weatherRes = await fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric&lang=it`);
  const airRes = await fetch(`https://api.openweathermap.org/data/2.5/air_pollution?lat=${lat}&lon=${lon}&appid=${API_KEY}`);

  if (!weatherRes.ok || !airRes.ok) throw new Error('Errore nel fetch dei dati');

  return {
    weatherData: await weatherRes.json(),
    airData: await airRes.json(),
  };
}

async function updateStats(cityName) {
  const city = cities[cityName.toLowerCase()];
  if (!city) {
    alert('Città non trovata!');
    return;
  }

  try {
    disasterListEl.innerHTML = '<p>Caricamento dati...</p>';

    const { lat, lon } = city;
    const { weatherData, airData } = await fetchWeatherAndAir(lat, lon);

    tempEl.textContent = `${weatherData.main.temp.toFixed(1)} °C`;
    feelsLikeEl.textContent = `${weatherData.main.feels_like.toFixed(1)} °C`;
    humidityEl.textContent = `${weatherData.main.humidity} %`;
    pressureEl.textContent = `${weatherData.main.pressure} hPa`;
    windSpeedEl.textContent = `${mpsToKmh(weatherData.wind.speed)} km/h`;

    const deg = weatherData.wind.deg;
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    windDirectionEl.textContent = dirs[Math.round(deg / 45) % 8];

    const rain = weatherData.rain?.['1h'] ?? 0;
    rainChanceEl.textContent = rain > 0 ? `Pioggia: ${rain} mm` : 'Nessuna pioggia';

    visibilityEl.textContent = `${(weatherData.visibility / 1000).toFixed(1)} km`;

    sunriseEl.textContent = new Date(weatherData.sys.sunrise * 1000).toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' });
    sunsetEl.textContent = new Date(weatherData.sys.sunset * 1000).toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' });

    uvIndexEl.textContent = 'N/D';

    airQualityEl.textContent = mapAQI(airData.list[0].main.aqi);
    mainPollutantsEl.textContent = formatPollutants(airData.list[0].components);

    updatePollen(cityName);

    disasterListEl.innerHTML = '<p>Nessuna calamità rilevata al momento.</p>';
  } catch (err) {
    console.error(err);
    disasterListEl.innerHTML = '<p>Errore nel caricamento dati.</p>';
  }
}

async function loadCities() {
  const res = await fetch('data/italian-cities.json');
  const cityArray = await res.json();

  cityArray.forEach(city => {
    cities[city.name.toLowerCase()] = { lat: city.lat, lon: city.lon };
    const option = document.createElement('option');
    option.value = city.name;
    cityList.appendChild(option);
  });
}

loadCities();

// Inizializza al primo invio/cambio
cityInput.addEventListener('change', () => {
  updateStats(cityInput.value);
});

loadCities().then(() => {
  cityInput.value = 'Roma';     // Imposta Roma come default nell'input
  updateStats('Roma');           // Carica subito dati meteo per Roma
});
