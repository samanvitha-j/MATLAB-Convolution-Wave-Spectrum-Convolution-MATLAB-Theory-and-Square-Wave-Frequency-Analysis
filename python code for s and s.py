import serial
import numpy as np
import matplotlib.pyplot as plt

# Adjust COM port and baud rate
ser = serial.Serial('COM6', 115200)  # Replace 'COM3' with your port
samples = []
sample_count = 500  # Match with Arduino

# Read samples from Serial
while len(samples) < sample_count:
    line = ser.readline().decode().strip()
    if line.isdigit():
        samples.append(int(line))

ser.close()

voltages = [val * (5.0 / 1023.0) for val in samples]


sampling_rate = 10000  # Hz
fft_result = np.fft.fft(samples)
frequencies = np.fft.fftfreq(len(samples), 1/sampling_rate)

# Only take the positive half
half = len(samples) // 2
fft_magnitude = np.abs(fft_result[:half])
freqs = frequencies[:half]

plt.plot(freqs, fft_magnitude)
plt.title("Frequency Spectrum")
plt.xlabel("Frequency (Hz)")
plt.ylabel("Amplitude")
plt.grid(True)
plt.show()