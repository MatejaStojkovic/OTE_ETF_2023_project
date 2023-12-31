import numpy as np


def norm_pdf(x, mean, var):
    return (1 / (2 * np.pi * var)**0.5) * np.exp(-0.5 * ((x - mean)**2 / var))


def log_norm_pdf(x, mean, var):
    return np.log(norm_pdf(x, mean, var))


class NaiveBayes:
    def __init__(self, multipah=False):
        self.symbols_phase_mean = None
        self.symbols_phase_var = None

        self.symbols_quadrature_mean = None
        self.symbols_quadrature_var = None

        self.symbols_frequency = None
        self.multipath = multipah

    def train(self, data, labels, unique_symbols):

        if len(data.shape) == 2:
            data = data[..., np.newaxis]
        else:
            data = np.moveaxis(data, [0], [-1])

        print(data.shape)

        phase = data.real
        quadrature = data.imag

        self.symbols_phase_mean = np.zeros(
            (len(unique_symbols), data.shape[-1]))
        self.symbols_phase_var = np.zeros(
            (len(unique_symbols), data.shape[-1]))
        self.symbols_quadrature_mean = np.zeros(
            (len(unique_symbols), data.shape[-1]))
        self.symbols_quadrature_var = np.zeros(
            (len(unique_symbols), data.shape[-1]))
        self.symbols_frequency = np.zeros(
            len(unique_symbols))

        for i, symbol in enumerate(unique_symbols):
            phase_symbol = phase[labels == symbol]
            quadrature_symbol = quadrature[labels == symbol]

            phase_mean = np.mean(phase_symbol, axis=0)
            phase_var = np.mean((phase_symbol - phase_mean)**2, axis=0)

            quadrature_mean = np.mean(quadrature_symbol, axis=0)
            quadrature_var = np.mean(
                (quadrature_symbol - quadrature_mean)**2, axis=0)

            self.symbols_phase_mean[i] = phase_mean
            self.symbols_phase_var[i] = phase_var
            self.symbols_quadrature_mean[i] = quadrature_mean
            self.symbols_quadrature_var[i] = quadrature_var
            self.symbols_frequency[i] = len(phase_symbol) / len(data)

    def predict(self, data, unique_symbols):
        if len(data.shape) == 2:
            data = data[..., np.newaxis]
        else:
            data = np.moveaxis(data, [0], [-1])
        phase = data.real
        quadrature = data.imag

        priorPhaseSymbol = np.zeros(
            data.shape + (len(unique_symbols), data.shape[-1]))
        priorQuadratureSymbol = np.zeros(
            data.shape + (len(unique_symbols), data.shape[-1]))

        for i, symbol in enumerate(unique_symbols):
            for j in range(data.shape[-1]):
                priorPhaseSymbol[..., i, j] = log_norm_pdf(
                    phase, self.symbols_phase_mean[i][j], self.symbols_phase_var[i][j])
                priorQuadratureSymbol[..., i, j] = log_norm_pdf(
                    quadrature, self.symbols_quadrature_mean[i][j], self.symbols_quadrature_var[i][j])

        probabilitySymbol = np.zeros(data.shape + (len(unique_symbols),))
        for i, symbol in enumerate(unique_symbols):
            probabilitySymbol[..., i] = np.sum(priorPhaseSymbol[..., i, :], axis=-1) + \
                np.sum(priorQuadratureSymbol[..., i, :], axis=-1) + \
                np.log(self.symbols_frequency[i])

        prediction = np.argmax(probabilitySymbol, axis=-1) + 1
        return prediction[..., 0]
