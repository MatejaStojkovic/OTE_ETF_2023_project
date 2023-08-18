import scipy.io
import numpy as np
import matplotlib.pyplot as plt


class DataParser:
    def __init__(self, filename):
        self.filename = filename
        mat = scipy.io.loadmat(filename)
        self.Labele_Kompleksni_simboli = mat["Labele_Kompleksni_simboli"]
        self.Labele_Redni_brojevi_simbola = mat["Labele_Redni_brojevi_simbola"]
        # stack labels 8 times to match the number of samples
        self.Labele_Kompleksni_simboli = np.stack(
            [self.Labele_Kompleksni_simboli[:, 0] for _ in range(8)], axis=0)
        self.Labele_Redni_brojevi_simbola = np.stack(
            [self.Labele_Redni_brojevi_simbola[:, 0] for _ in range(8)], axis=0)
        self.Simboli_na_prijemu_fazni_offset_uzorak = mat["Simboli_na_prijemu_fazni_offset_uzorak"]
        self.Simboli_na_prijemu_multipath_uzorak = mat["Simboli_na_prijemu_multipath_uzorak"]
        self.Simboli_na_prijemu_uzorak = mat["Simboli_na_prijemu_uzorak"]
        self.SNR = {
            0: 0,
            1: 3,
            2: 6,
            3: 9,
            4: 12,
            5: 15,
            6: 18,
            7: 21,
        }
        self.train_slice = np.index_exp[..., :, :20000]
        self.verify_slice = np.index_exp[..., :, 20000:25000]
        self.test_slice = np.index_exp[..., :, 25000:50000]

        self.train_slice_v2 = np.index_exp[..., 1:5, :20000]
        self.verify_slice_v2 = np.index_exp[..., 1:5, 20000:25000]
        self.test_slice_v2 = np.index_exp[..., :, 25000:]

        Simboli = self.Simboli_na_prijemu_multipath_uzorak
        self.stacked_simboli_test = np.stack(
            [Simboli[:, :20000], Simboli[:, 1:20001], Simboli[:, 2:20002]], axis=0)
        self.stacked_simboli_validation = np.stack(
            [Simboli[:, 20003:25003], Simboli[:, 20004:25004], Simboli[:, 20005:25005]], axis=0)
        self.stacked_simboli_train = np.stack(
            [Simboli[:, 25006:50006], Simboli[:, 25007:50007], Simboli[:, 25008:50008]], axis=0)
        self.stacked_labels_test = self.Simboli_na_prijemu_multipath_uzorak[:, 3:20003]
        self.stacked_labels_validation = self.Simboli_na_prijemu_multipath_uzorak[
            :, 20006:25006]
        self.stacked_labels_train = self.Simboli_na_prijemu_multipath_uzorak[:, 25009:50009]

    def get_train_dataV1(self, complex = False):
        if complex: return self.Simboli_na_prijemu_uzorak[self.train_slice], self.Labele_Kompleksni_simboli[self.train_slice]
        else: return self.Simboli_na_prijemu_uzorak[self.train_slice], self.Labele_Redni_brojevi_simbola[self.train_slice]

    def get_train_dataV2(self, ):
        return self.Simboli_na_prijemu_uzorak[self.train_slice_v2], self.Labele_Redni_brojevi_simbola[self.train_slice_v2]

    def get_validation_dataV1(self,):
        return self.Simboli_na_prijemu_uzorak[self.verify_slice], self.Labele_Redni_brojevi_simbola[self.verify_slice]

    def get_validation_dataV2(self, ):
        return self.Simboli_na_prijemu_uzorak[self.verify_slice_v2], self.Labele_Redni_brojevi_simbola[self.verify_slice_v2]

    def get_test_dataV1(self, complex = False):
        if complex: return self.Simboli_na_prijemu_uzorak[self.test_slice], self.Labele_Kompleksni_simboli[self.test_slice]
        else: return self.Simboli_na_prijemu_uzorak[self.test_slice], self.Labele_Redni_brojevi_simbola[self.test_slice]

    def get_test_dataV2(self, ):
        return self.Simboli_na_prijemu_uzorak[self.test_slice_v2], self.Labele_Redni_brojevi_simbola[self.test_slice_v2]

    def get_train_multipath(self,):
        return self.stacked_simboli_train, self.stacked_labels_train

    def get_validation_multipath(self, ):
        return self.stacked_simboli_validation, self.stacked_labels_validation

    def get_test_multipath(self, ):
        return self.stacked_simboli_test, self.stacked_labels_test
    
    def get_complex_symbols(self, ):
        return self.Labele_Kompleksni_simboli


if __name__ == "__main__":
    dataParser = DataParser("data/DataForML.mat")
    Simboli, Labele = dataParser.get_train_dataV1()
    print(Simboli.shape)
    print(Labele.shape)
    Simboli, Labele = dataParser.get_train_dataV2()
    print(Simboli.shape)
    print(Labele.shape)
