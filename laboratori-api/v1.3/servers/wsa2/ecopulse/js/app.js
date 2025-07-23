const cityCoords = {
  milano: { lat: 45.4642, lon: 9.19 },
  roma: { lat: 41.9028, lon: 12.4964 },
  napoli: { lat: 40.8522, lon: 14.2681 },
  torino: { lat: 45.0703, lon: 7.6869 },
  firenze: { lat: 43.7696, lon: 11.2558 },
};

// Inserisci qui la tua API key OpenWeatherMap
const API_KEY = '8d2a751ccdf85468f6965805f3b51243';

const citySelect = document.getElementById('city');
const tempEl = document.getElementById('temp');
const airQualityEl = document.getElementById('air-quality');
const humidityEl = document.getElementById('humidity');
const uvIndexEl = document.getElementById('uv-index');
const windSpeedEl = document.getElementById('wind-speed');
const pressureEl = document.getElementById('pressure');
const rainChanceEl = document.getElementById('rain-chance');
const mainPollutantsEl = document.getElementById('main-pollutants');
const disasterListEl = document.getElementById('disaster-list');
const pollenEl = document.getElementById('pollen');

const pollenData = {
  milano: 'Moderato (graminacee, betulla)',
  roma: 'Basso (parietaria)',
  napoli: 'Alto (olivo, cipresso)',
  torino: 'Moderato (betulla, quercia)',
  firenze: 'Basso (graminacee)',
};

async function fetchWeatherAndAir(city) {
  const { lat, lon } = cityCoords[city];

  try {
    // Fetch meteo
    const weatherRes = await fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric&lang=it`);
    if (!weatherRes.ok) throw new Error('Errore nel fetch meteo');
    const weatherData = await weatherRes.json();

    // Fetch qualità aria
    const airRes = await fetch(`https://api.openweathermap.org/data/2.5/air_pollution?lat=${lat}&lon=${lon}&appid=${API_KEY}`);
    if (!airRes.ok) throw new Error('Errore nel fetch aria');
    const airData = await airRes.json();

    return { weatherData, airData };
  } catch (error) {
    console.error('Errore fetching dati reali:', error);
    throw error;
  }
}

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

  const pollutants = [];
  for (const [key, value] of Object.entries(components)) {
    if (value > 0 && pollutantNames[key]) {
      pollutants.push(`${pollutantNames[key]}: ${value.toFixed(2)} µg/m³`);
    }
  }
  return pollutants.join(', ') || '--';
}

function updatePollen(city) {
  pollenEl.textContent = pollenData[city] || '--';
}

async function updateStatsReal(city) {
  try {
    disasterListEl.innerHTML = '<p>Caricamento dati...</p>';

    const { weatherData, airData } = await fetchWeatherAndAir(city);

    // Temperatura
    tempEl.textContent = `${weatherData.main.temp.toFixed(1)} °C`;
    // Umidità
    humidityEl.textContent = `${weatherData.main.humidity} %`;
    // Pressione
    pressureEl.textContent = `${weatherData.main.pressure} hPa`;
    // Vento (convertito da m/s a km/h)
    windSpeedEl.textContent = `${mpsToKmh(weatherData.wind.speed)} km/h`;
    // Possibilità pioggia
    const rainVol = weatherData.rain?.['1h'] ?? 0;
    rainChanceEl.textContent = rainVol > 0 ? `Pioggia: ${rainVol} mm nell'ultima ora` : 'Nessuna pioggia';
    // Indice UV (OpenWeatherMap API separata, qui "N/D")
    uvIndexEl.textContent = 'N/D';

    // Qualità aria (AQI)
    const airQualityIndex = airData.list[0].main.aqi;
    airQualityEl.textContent = mapAQI(airQualityIndex);

    // Pollutanti principali
    const components = airData.list[0].components;
    mainPollutantsEl.textContent = formatPollutants(components);

    // Polline (mock)
    updatePollen(city);

    // Calamità (mock, in attesa di integrazione API reali)
    disasterListEl.innerHTML = '<p>Nessuna calamità rilevata al momento.</p>';

  } catch (error) {
    tempEl.textContent = '-- °C';
    airQualityEl.textContent = '--';
    humidityEl.textContent = '-- %';
    uvIndexEl.textContent = '--';
    windSpeedEl.textContent = '-- km/h';
    pressureEl.textContent = '-- hPa';
    rainChanceEl.textContent = '--';
    mainPollutantsEl.textContent = '--';
    pollenEl.textContent = '--';
    disasterListEl.innerHTML = '<p>Errore nel caricamento dati. Riprova più tardi.</p>';
  }
}

// Inizializza con la città selezionata
updateStatsReal(citySelect.value);

// Cambia dati quando cambia la città
citySelect.addEventListener('change', e => {
  updateStatsReal(e.target.value);
});
