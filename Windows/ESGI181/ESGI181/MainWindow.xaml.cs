using Newtonsoft.Json;
using System.IO;
using System.Windows;
using System.Windows.Controls;

namespace ESGI181
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    /// 
    using System;
    using System.Text.RegularExpressions;
    using System.Windows.Input;

    public partial class MainWindow : Window
    {
        private decimal AlturaBase1 = 0;
        private decimal RaioBaseCima1 = 0;
        private decimal RaioBaseBaixo1 = 0;
        private decimal Porta = 0;
        private decimal VFundo = 0;
        private decimal AlturaTopo1 = 0;
        private decimal AlturaPescoço1 = 0;
        private decimal VolumeTotal1 = 0;
        private decimal RaioPescoço1 = 0;
        private bool IsUpdating = false;

        public class Preset
        {
            public string PresetName { get; set; }
            public Dictionary<string, object> Options { get; set; }
            public Dictionary<string, string> Values { get; set; }
        }

        public MainWindow()
        {
            InitializeComponent();

            List<Preset> presets = ReadPresetsFromFile();

            foreach (Preset item in presets)
            {
                BoxPresets.Items.Add(item.PresetName);
            }

            CentradoCheckBox.IsChecked = true;
            CilindroBaseCheckBox.IsChecked = true;
            FundoNaoCheckBox.IsChecked = true;
            PortaRetangularCheckBox.IsChecked = true;
            PortaDentroCheckBox.IsChecked = true;
            PescoçoAdicionalNaoCheckBox.IsChecked = true;
        }

        private void PositiveNumberTextBox_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !IsTextAllowed(e.Text);
        }

        private void PositiveNumberTextBox_Pasting(object sender, DataObjectPastingEventArgs e)
        {
            if (e.DataObject.GetDataPresent(typeof(string)))
            {
                string text = (string)e.DataObject.GetData(typeof(string));
                if (!IsTextAllowed(text))
                {
                    e.CancelCommand();
                }
            }
            else
            {
                e.CancelCommand();
            }
        }

        private static bool IsTextAllowed(string text)
        {
            Regex regex = new Regex(@"^\d*[,]?\d*$"); // Apenas números positivos
            return regex.IsMatch(text);
        }

        private void CalculateVolume_Click(object sender, RoutedEventArgs e)
        {
            Resultado.Content = string.Empty;
            try
            {
                decimal VolumeTotal = 0;
                decimal DiametroPescoço = decimal.Parse(DiametroPescoçoTextBox.Text);
                decimal RaioPescoço = DiametroPescoço / 2m;
                RaioPescoço1 = RaioPescoço;
                decimal AlturaPescoço = decimal.Parse(AlturaPequenaPescoçoTextBox.Text);
                decimal AlturaPequenaPescoço = decimal.Parse(AlturaPequenaPescoçoTextBox.Text);
                decimal DiametroBase = decimal.Parse(DiametroBaseTextBox.Text);
                decimal RaioBase = DiametroBase / 2m;
                RaioBaseBaixo1 = RaioBase;
                decimal DiametroPequenoPorta = decimal.Parse(DiametroPequenoElipseTextBox.Text);
                decimal DiametroGrandePorta = decimal.Parse(DiametroGrandeElipseTextBox.Text);
                decimal Espessura = decimal.Parse(EspessuraTextBox.Text);
                decimal VolumePorta = 0;
                decimal RaioBaixoTopo = 0;
                decimal AlturaTotal = decimal.Parse(AlturaTotalTextBox.Text);
                decimal AlturaAux = 0;
                decimal Hipotenusa = 0;

                if (ConeBaseCheckBox.IsChecked == true)
                {
                    decimal Angulo = decimal.Parse(AnguloTextBox.Text) - 90m;
                    decimal AnguloRad = Angulo * (decimal)Math.PI / 180m;

                    if (CentradoCheckBox.IsChecked == true)
                    {
                        Hipotenusa = decimal.Parse(HipotenusaTextBox.Text);
                        RaioBaixoTopo = RaioPescoço + Hipotenusa*((decimal)Math.Cos((double)AnguloRad));
                        RaioBaseCima1 = RaioBaixoTopo;
                    }
                    if (NaoCentradoCheckBox.IsChecked == true)
                    {
                        RaioBaixoTopo = (decimal)Math.Cos((double)AnguloRad);
                        RaioBaseCima1 = RaioBaixoTopo;
                    }
                }

                if (CilindroBaseCheckBox.IsChecked == true)
                {
                    RaioBaixoTopo = RaioBase;
                    RaioBaseBaixo1 = RaioBase;
                    RaioBaseCima1 = RaioBase;
                }

                if (CentradoCheckBox.IsChecked == true)
                {
                    Hipotenusa = decimal.Parse(HipotenusaTextBox.Text);
                    decimal cateto = (RaioBaixoTopo - RaioPescoço);
                    decimal AlturaTopo = 0;

                    try
                    {
                        AlturaTopo = (decimal)Math.Sqrt((double)(Hipotenusa * Hipotenusa - cateto * cateto));
                    }
                    catch (Exception)
                    {
                        MessageBox.Show("Altura impossivel de calcular!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        return;
                    }

                    // Calcular o volume
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * AlturaPescoço;
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * AlturaTopo * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioPescoço * RaioPescoço) + (RaioPescoço * RaioBaixoTopo));

                    if (VolumeTopo < 0 || VolumePescoço < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    AlturaAux = AlturaTopo + AlturaPescoço;

                    AlturaTopo1 = AlturaTopo;
                    AlturaPescoço1 = AlturaPescoço;

                    VolumePescoçoLabel.Content = (VolumePescoço / 1000m).ToString("F3");
                    VolumeTopoLabel.Content = (VolumeTopo / 1000m).ToString("F3");
                }

                if (NaoCentradoCheckBox.IsChecked == true)
                {
                    decimal AlturaGrandePescoço = decimal.Parse(AlturaGrandePescoçoTextBox.Text);

                    // Calcular o volume
                    decimal AlturaTopo = (RaioBaixoTopo * (AlturaGrandePescoço - AlturaPequenaPescoço)) / (RaioPescoço * 2);
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * ((AlturaGrandePescoço + AlturaPequenaPescoço) / 2m);
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * RaioBaixoTopo * RaioBaixoTopo * AlturaTopo;

                    if (VolumeTopo < 0 || VolumePescoço < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    AlturaAux = AlturaGrandePescoço;

                    AlturaTopo1 = AlturaTopo;
                    AlturaPescoço1 = AlturaPescoço;

                    VolumePescoçoLabel.Content = (VolumePescoço / 1000m).ToString("F3");
                    VolumeTopoLabel.Content = (VolumeTopo / 1000m).ToString("F3");
                }

                if (PescoçoAdicionalSimCheckBox.IsChecked == true)
                {
                    decimal AlturaPescoçoAdicional = decimal.Parse(AlturaPescoçoAdicionalTextBox.Text);
                    decimal DiametroPescoçoAdicional = decimal.Parse(DiametroPescoçoAdicionalTextBox.Text);
                    decimal RaioPescoçoAdicional = DiametroPescoçoAdicional / 2m;

                    AlturaAux = AlturaAux + AlturaPescoçoAdicional;

                    decimal VolumePescoçoAdicional = (decimal)Math.PI * RaioPescoçoAdicional * RaioPescoçoAdicional * AlturaPescoçoAdicional;

                    MessageBox.Show(VolumePescoçoAdicional.ToString());

                    VolumeTotal = VolumeTotal + VolumePescoçoAdicional;
                }

                if (ConeBaseCheckBox.IsChecked == true)
                {
                    decimal AlturaBase = 0;

                    if (FundoSimCheckBox.IsChecked == true)
                    {
                        AlturaBase = decimal.Parse(AlturaTotalTextBox.Text);
                        AlturaBase1 = AlturaBase;
                    }
                    else
                    {
                        AlturaBase = AlturaTotal - AlturaAux;
                        AlturaBase1 = AlturaBase;
                    }
                    // Calcular a Volume da base
                    decimal VolumeBase = (1m / 3m) * (decimal)Math.PI * (AlturaBase) * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioBase * RaioBase) + (RaioBase * RaioBaixoTopo));

                    if (VolumeBase < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }

                    VolumeTotal = VolumeTotal + VolumeBase;

                    VolumeBaseLabel.Content = (VolumeBase / 1000m).ToString("F3");
                }

                if (CilindroBaseCheckBox.IsChecked == true)
                {
                    decimal AlturaBase = 0;

                    if (FundoSimCheckBox.IsChecked == true)
                    {
                        AlturaBase = decimal.Parse(AlturaTotalTextBox.Text);
                        AlturaBase1 = AlturaBase;
                    }
                    else
                    {
                        AlturaBase = AlturaTotal - AlturaAux;
                        AlturaBase1 = AlturaBase;
                    }

                    // Calcular a area da base
                    decimal AreaBase = (decimal)Math.PI * RaioBase * RaioBase;

                    // Calcular o volume do cilindro
                    decimal VolumeBase = AreaBase * AlturaBase;

                    if (VolumeBase < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }

                    VolumeTotal = VolumeTotal + VolumeBase;

                    RaioBaixoTopo = RaioBase;

                    VolumeBaseLabel.Content = (VolumeBase / 1000m).ToString("F3");
                }

                if (FundoSimCheckBox.IsChecked == true)
                {
                    decimal HipotenusaFundo = decimal.Parse(HipotenusaFundoTextBox.Text);
                    decimal DiametroTubo = decimal.Parse(DiametroTuboTextBox.Text);
                    decimal RaioTubo = DiametroTubo / 2m;
                    decimal ComprimentoTubo = decimal.Parse(ComprimentoTuboTextBox.Text);

                    decimal cateto = (RaioBase - RaioTubo);

                    decimal AlturaFundo = 0;

                    try
                    {
                        AlturaFundo = (decimal)Math.Sqrt((double)(HipotenusaFundo * HipotenusaFundo - cateto * cateto));
                    }
                    catch (Exception)
                    {
                        MessageBox.Show("Altura impossivel de calcular!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        return;
                    }

                    decimal AreaBaseTubo = (decimal)Math.PI * RaioTubo * RaioTubo;

                    // Calcular o volume do cone
                    decimal VolumeConeFundo = (1m / 3m) * (decimal)Math.PI * AlturaFundo * RaioBase * RaioBase;

                    decimal VolumeTuboFundo = AreaBaseTubo * ComprimentoTubo;

                    if (VolumeConeFundo < 0 || VolumeTuboFundo < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }

                    VolumeTotal = VolumeTotal + VolumeConeFundo + VolumeTuboFundo;

                    VFundo = VolumeConeFundo + VolumeTuboFundo;

                    VolumeFundoLabel.Content = ((VolumeConeFundo + VolumeTuboFundo) / 1000m).ToString("F3");
                }

                if (PortaOvalCheckBox.IsChecked == true)
                {
                    decimal RaioPequenoPorta = DiametroPequenoPorta / 2m;
                    decimal RaioGrandePorta = DiametroGrandePorta / 2m;

                    VolumePorta = ((decimal)Math.PI * RaioPequenoPorta * RaioGrandePorta) * Espessura;

                    if (VolumePorta < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }
                }

                if (PortaRetangularCheckBox.IsChecked == true)
                {
                    VolumePorta = DiametroPequenoPorta * DiametroGrandePorta * Espessura;

                    if (VolumePorta < 0)
                    {
                        MessageBox.Show("Volume negativo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                        Resultado.Content = string.Empty;
                        VolumePescoçoLabel.Content = string.Empty;
                        VolumeBaseLabel.Content = string.Empty;
                        VolumeFundoLabel.Content = string.Empty;
                        VolumeTopoLabel.Content = string.Empty;
                        VolumePortaLabel.Content = string.Empty;
                        return;
                    }
                }

                if (PortaDentroCheckBox.IsChecked == true)
                {
                    Porta = 0 - VolumePorta;

                    VolumeTotal = VolumeTotal - VolumePorta;

                    VolumePortaLabel.Content = (VolumePorta / 1000m).ToString("F3");
                }
                else
                {
                    Porta = VolumePorta;

                    VolumeTotal = VolumeTotal + VolumePorta;

                    VolumePortaLabel.Content = (VolumePorta / 1000m).ToString("F3");
                }

                Resultado.Content = (VolumeTotal / 1000m).ToString("F3");
                VolumeTotal1 = VolumeTotal;
            }
            catch (FormatException)
            {
                // Exibir uma mensagem de erro se a conversão falhar
                MessageBox.Show("Por favor, insira todos os valores numéricos válidos.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void DoorCheckBox_Checked(object sender, RoutedEventArgs e)
        {
            CheckBoxChanged(sender);
        }

        private void DoorCheckBox_Unchecked(object sender, RoutedEventArgs e)
        {
            CheckBoxChanged(sender);
        }

        private void CheckBoxChanged(object sender)
        {
            if ((sender == CentradoCheckBox || sender == NaoCentradoCheckBox) && (CentradoCheckBox.IsChecked == false) && (NaoCentradoCheckBox.IsChecked == false))
            {
                CentradoCheckBox.IsChecked = true;
                ConeTopo.Visibility = Visibility.Collapsed;
                PescoçoNaoCentrado.Visibility = Visibility.Collapsed;
                TroncoTopo.Visibility = Visibility.Visible;
                PescoçoCentrado.Visibility = Visibility.Visible;
                AlturaPequenaPescoço.Content = "Altura Pescoço (a)";
                AlturaGrandePescoço.Visibility = Visibility.Collapsed;
                AlturaGrandePescoçoTextBox.Visibility = Visibility.Collapsed;
                Hipotenusa.Visibility = Visibility.Visible;
                HipotenusaTextBox.Visibility = Visibility.Visible;
            }
            if (sender == CentradoCheckBox && CentradoCheckBox.IsChecked == true)
            {
                NaoCentradoCheckBox.IsChecked = false;
                ConeTopo.Visibility = Visibility.Collapsed;
                PescoçoNaoCentrado.Visibility = Visibility.Collapsed;
                TroncoTopo.Visibility = Visibility.Visible;
                PescoçoCentrado.Visibility = Visibility.Visible;
                AlturaPequenaPescoço.Content = "Altura Pescoço (a)";
                AlturaGrandePescoço.Visibility = Visibility.Collapsed;
                AlturaGrandePescoçoTextBox.Visibility = Visibility.Collapsed;
                Hipotenusa.Visibility = Visibility.Visible;
                HipotenusaTextBox.Visibility = Visibility.Visible;
            }
            else if (sender == NaoCentradoCheckBox && NaoCentradoCheckBox.IsChecked == true)
            {
                if (ConeBaseCheckBox.IsChecked == true && !IsUpdating)
                {
                    NaoCentradoCheckBox.IsChecked = false;
                    MessageBox.Show("Cuba desconhecida.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                CentradoCheckBox.IsChecked = false;
                ConeTopo.Visibility = Visibility.Visible;
                PescoçoNaoCentrado.Visibility = Visibility.Visible;
                TroncoTopo.Visibility = Visibility.Collapsed;
                PescoçoCentrado.Visibility = Visibility.Collapsed;
                AlturaPequenaPescoço.Content = "Altura Pequena (ap)";
                AlturaGrandePescoço.Visibility = Visibility.Visible;
                AlturaGrandePescoçoTextBox.Visibility = Visibility.Visible;
                Hipotenusa.Visibility = Visibility.Collapsed;
                HipotenusaTextBox.Visibility = Visibility.Collapsed;
            }

            /*---------------------------------------------------*/

            if ((sender == PescoçoAdicionalSimCheckBox || sender == PescoçoAdicionalNaoCheckBox) && (PescoçoAdicionalSimCheckBox.IsChecked == false) && (PescoçoAdicionalNaoCheckBox.IsChecked == false))
            {
                PescoçoAdicionalNaoCheckBox.IsChecked = true;
                AlturaPescoçoAdicional.Visibility = Visibility.Collapsed;
                DiametroPescoçoAdicional.Visibility = Visibility.Collapsed;
                AlturaPescoçoAdicionalTextBox.Visibility = Visibility.Collapsed;
                DiametroPescoçoAdicionalTextBox.Visibility = Visibility.Collapsed;
            }

            if (sender == PescoçoAdicionalSimCheckBox && PescoçoAdicionalSimCheckBox.IsChecked == true)
            {
                PescoçoAdicionalNaoCheckBox.IsChecked = false;
                AlturaPescoçoAdicional.Visibility = Visibility.Visible;
                DiametroPescoçoAdicional.Visibility = Visibility.Visible;
                AlturaPescoçoAdicionalTextBox.Visibility = Visibility.Visible;
                DiametroPescoçoAdicionalTextBox.Visibility = Visibility.Visible;

            }
            else if (sender == PescoçoAdicionalNaoCheckBox && PescoçoAdicionalNaoCheckBox.IsChecked == true)
            {
                PescoçoAdicionalSimCheckBox.IsChecked = false;
                AlturaPescoçoAdicional.Visibility = Visibility.Collapsed;
                DiametroPescoçoAdicional.Visibility = Visibility.Collapsed;
                AlturaPescoçoAdicionalTextBox.Visibility = Visibility.Collapsed;
                DiametroPescoçoAdicionalTextBox.Visibility = Visibility.Collapsed;

            }

            /*---------------------------------------------------*/

            if ((sender == ConeBaseCheckBox || sender == CilindroBaseCheckBox) && (ConeBaseCheckBox.IsChecked == false) && (CilindroBaseCheckBox.IsChecked == false))
            {
                CilindroBaseCheckBox.IsChecked = true;
                if (FundoSimCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Visible;
                    Fundo1.Visibility = Visibility.Collapsed;
                }
                if (FundoNaoCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Collapsed;
                    Fundo1.Visibility = Visibility.Collapsed;
                }
                CilindroBase.Visibility = Visibility.Visible;
                TroncoBase.Visibility = Visibility.Collapsed;
                AnguloTextBox.Visibility = Visibility.Collapsed;
                Angulo.Visibility = Visibility.Collapsed;
            }
            if (sender == CilindroBaseCheckBox && CilindroBaseCheckBox.IsChecked == true)
            {
                ConeBaseCheckBox.IsChecked = false;
                if (FundoSimCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Visible;
                    Fundo1.Visibility = Visibility.Collapsed;
                }
                if (FundoNaoCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Collapsed;
                    Fundo1.Visibility = Visibility.Collapsed;
                }
                CilindroBase.Visibility = Visibility.Visible;
                TroncoBase.Visibility = Visibility.Collapsed;
                AnguloTextBox.Visibility = Visibility.Collapsed;
                Angulo.Visibility = Visibility.Collapsed;
            }
            else if (sender == ConeBaseCheckBox && ConeBaseCheckBox.IsChecked == true)
            {
                if (NaoCentradoCheckBox.IsChecked == true)
                {
                    ConeBaseCheckBox.IsChecked = false;
                    MessageBox.Show("Cuba desconhecida.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                CilindroBaseCheckBox.IsChecked = false;
                if (FundoSimCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Collapsed;
                    Fundo1.Visibility = Visibility.Visible;
                }
                if (FundoNaoCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Collapsed;
                    Fundo1.Visibility = Visibility.Collapsed;
                }
                CilindroBase.Visibility = Visibility.Collapsed;
                TroncoBase.Visibility = Visibility.Visible;
                AnguloTextBox.Visibility = Visibility.Visible;
                Angulo.Visibility = Visibility.Visible;
            }

            /*---------------------------------------------------*/

            if ((sender == FundoSimCheckBox || sender == FundoNaoCheckBox) && (FundoSimCheckBox.IsChecked == false) && (FundoNaoCheckBox.IsChecked == false))
            {
                FundoNaoCheckBox.IsChecked = true;
                AlturaTotal.Content = "Altura Total (A):";
                ComprimentoTuboTextBox.Visibility = Visibility.Collapsed;
                ComprimentoTubo.Visibility = Visibility.Collapsed;
                DiametroTuboTextBox.Visibility = Visibility.Collapsed;
                DiametroTubo.Visibility = Visibility.Collapsed;
                Fundo.Visibility = Visibility.Collapsed;
                Fundo1.Visibility = Visibility.Collapsed;
                HipotenusaFundo.Visibility = Visibility.Collapsed;
                HipotenusaFundo.Visibility = Visibility.Collapsed;
            }
            if (sender == FundoSimCheckBox && FundoSimCheckBox.IsChecked == true)
            {
                FundoNaoCheckBox.IsChecked = false;
                AlturaTotal.Content = "Altura Base (A):";
                if (ConeBaseCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Collapsed;
                    Fundo1.Visibility = Visibility.Visible;
                }
                if (CilindroBaseCheckBox.IsChecked == true)
                {
                    Fundo.Visibility = Visibility.Visible;
                    Fundo1.Visibility = Visibility.Collapsed;
                }
                HipotenusaFundo.Visibility = Visibility.Visible;
                HipotenusaFundoTextBox.Visibility = Visibility.Visible;
                ComprimentoTuboTextBox.Visibility = Visibility.Visible;
                ComprimentoTubo.Visibility = Visibility.Visible;
                DiametroTuboTextBox.Visibility = Visibility.Visible;
                DiametroTubo.Visibility = Visibility.Visible;
            }
            else if (sender == FundoNaoCheckBox && FundoNaoCheckBox.IsChecked == true)
            {
                FundoSimCheckBox.IsChecked = false;
                AlturaTotal.Content = "Altura Total (A):";
                Fundo.Visibility = Visibility.Collapsed;
                Fundo1.Visibility = Visibility.Collapsed;
                HipotenusaFundo.Visibility = Visibility.Collapsed;
                HipotenusaFundoTextBox.Visibility = Visibility.Collapsed;
                ComprimentoTuboTextBox.Visibility = Visibility.Collapsed;
                ComprimentoTubo.Visibility = Visibility.Collapsed;
                DiametroTuboTextBox.Visibility = Visibility.Collapsed;
                DiametroTubo.Visibility = Visibility.Collapsed;
            }

            /*---------------------------------------------------*/

            if ((sender == PortaOvalCheckBox || sender == PortaRetangularCheckBox) && (PortaOvalCheckBox.IsChecked == false) && (PortaRetangularCheckBox.IsChecked == false))
            {
                PortaRetangularCheckBox.IsChecked = true;
                DiametroGrandeElipse.Content = "Comprimento Porta (cp):";
                DiametroPequenoElipse.Content = "Largura Porta (lp):";
            }
            if (sender == PortaOvalCheckBox && PortaOvalCheckBox.IsChecked == true)
            {
                PortaRetangularCheckBox.IsChecked = false;
                DiametroGrandeElipse.Content = "Diametro Grande Elipse (dg):";
                DiametroPequenoElipse.Content = "Diametro Pequeno Elipse (dp):";
            }
            else if (sender == PortaRetangularCheckBox && PortaRetangularCheckBox.IsChecked == true)
            {
                PortaOvalCheckBox.IsChecked = false;
                DiametroGrandeElipse.Content = "Comprimento Porta (cp):";
                DiametroPequenoElipse.Content = "Largura Porta (lp):";
            }

            /*---------------------------------------------------*/

            if ((sender == PortaForaCheckBox || sender == PortaDentroCheckBox) && (PortaForaCheckBox.IsChecked == false) && (PortaDentroCheckBox.IsChecked == false))
            {
                PortaDentroCheckBox.IsChecked = true;
            }
            if (sender == PortaForaCheckBox && PortaForaCheckBox.IsChecked == true)
            {
                PortaDentroCheckBox.IsChecked = false;
            }
            else if (sender == PortaDentroCheckBox && PortaDentroCheckBox.IsChecked == true)
            {
                PortaForaCheckBox.IsChecked = false;
            }
        }

        private void CalculateVolumeAtual_Click(object sender, RoutedEventArgs e)
        {
            VolumeFundoLabel.Content = string.Empty;

            if (string.IsNullOrEmpty(VolumePescoçoLabel.Content?.ToString()))
            {
                MessageBox.Show("Sem valores para calcular o volume atual", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            decimal AlturaTotal = AlturaTopo1 + AlturaPescoço1 + AlturaBase1;
            decimal VolumeAtual = 0;
            decimal AlturaAtual = decimal.Parse(AlturaCalcularVolumeTextBox.Text);
            decimal DiametroPequenoPorta = decimal.Parse(DiametroPequenoElipseTextBox.Text);
            decimal DiametroGrandePorta = decimal.Parse(DiametroGrandeElipseTextBox.Text);
            decimal Volume = 0;

            if (AlturaTotal < AlturaAtual)
            {
                MessageBox.Show("A altura atual não pode exceder a altura do recipiente", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (CilindroBaseCheckBox.IsChecked == true)
            {
                if (AlturaBase1 >= AlturaAtual) /*Feito*/
                {
                    Volume = (decimal)Math.PI * RaioBaseBaixo1 * RaioBaseBaixo1 * AlturaAtual;
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    ResultadoAtual.Content = (VolumeAtual / 1000m).ToString("F3");
                    ResultadoVazio.Content = ((VolumeTotal1 - VolumeAtual) / 1000m).ToString("F3");
                    VolumeAtual = 0;
                    Volume = 0;
                    return;
                }
                else /*Feito*/
                {
                    Volume = (decimal)Math.PI * RaioBaseBaixo1 * RaioBaseBaixo1 * AlturaBase1;
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    Volume = 0;
                    AlturaAtual = AlturaAtual - AlturaBase1;
                }
            }

            if (ConeBaseCheckBox.IsChecked == true)
            {
                if (AlturaBase1 >= AlturaAtual) /*Feito*/
                {
                    decimal R = (RaioBaseBaixo1 - RaioBaseCima1);
                    decimal r = RaioBaseBaixo1 - (AlturaAtual * (R / AlturaBase1));
                    decimal VAux = (RaioBaseBaixo1 * RaioBaseBaixo1) + (r * r) + (RaioBaseBaixo1 * r);

                    Volume = (1m / 3m) * (decimal)Math.PI * AlturaAtual * VAux;
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    ResultadoAtual.Content = (VolumeAtual / 1000m).ToString("F3");
                    ResultadoVazio.Content = ((VolumeTotal1 - VolumeAtual) / 1000m).ToString("F3");
                    VolumeAtual = 0;
                    Volume = 0;
                    return;
                }
                else /*Feito*/
                {
                    Volume = (1m / 3m) * (decimal)Math.PI * (AlturaBase1) * ((RaioBaseBaixo1 * RaioBaseBaixo1) + (RaioBaseCima1 * RaioBaseCima1) + (RaioBaseCima1 * RaioBaseBaixo1));
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    Volume = 0;
                    AlturaAtual = AlturaAtual - AlturaBase1;
                }
            }

            if (CentradoCheckBox.IsChecked == true)
            {
                if ((AlturaAtual <= AlturaTopo1)) /*Feito*/
                {
                    decimal R = (RaioBaseCima1 - RaioPescoço1);
                    decimal r = RaioBaseCima1 - (AlturaAtual * (R / AlturaTopo1));
                    decimal VAux = (RaioBaseCima1 * RaioBaseCima1) + (r * r) + (RaioBaseCima1 * r);
                    Volume = (1m / 3m) * (decimal)Math.PI * AlturaAtual * VAux;

                    VolumeAtual = VolumeAtual + Volume;
                    Volume = 0;
                    ResultadoAtual.Content = (VolumeAtual / 1000m).ToString("F3");
                    ResultadoVazio.Content = ((VolumeTotal1 - VolumeAtual) / 1000m).ToString("F3");
                    VolumeAtual = 0;
                    return;
                }
                else /*Feito*/
                {
                    decimal VAux = (RaioBaseCima1 * RaioBaseCima1) + (RaioPescoço1 * RaioPescoço1) + (RaioBaseCima1 * RaioPescoço1);
                    Volume = (1m / 3m) * (decimal)Math.PI * AlturaTopo1 * VAux;

                    VolumeAtual = VolumeAtual + Volume;
                    Volume = 0;
                    AlturaAtual = AlturaAtual - AlturaTopo1;

                    Volume = (decimal)Math.PI * RaioPescoço1 * RaioPescoço1 * AlturaAtual;

                    VolumeAtual = VolumeAtual + Volume;
                    Volume = 0;
                    ResultadoAtual.Content = (VolumeAtual / 1000m).ToString("F3");
                    ResultadoVazio.Content = ((VolumeTotal1 - VolumeAtual) / 1000m).ToString("F3");
                    AlturaTotal = AlturaTopo1 + AlturaPescoço1 + AlturaBase1;
                    VolumeAtual = 0;
                    AlturaAtual = 0;
                    return;
                }
            }

            if (NaoCentradoCheckBox.IsChecked == true)
            {
                MessageBox.Show("Topo e Pescoço não contabilizados");
                /*if ((AlturaTotal <= AlturaTopo1))
                {
                    VolumeAtual = VolumeAtual + (1m / 3m) * (decimal)Math.PI * ((RaioBaseCima1 * RaioBaseCima1) + (RaioPescoço1 * RaioPescoço1) + (RaioPescoço1 * RaioBaseCima1));
                    ResultadoAtual.Content = VolumeAtual / 1000m;
                    RaioPescoço1 = 0;
                    AlturaBase1 = 0;
                    RaioBaseBaixo1 = 0;
                    RaioBaseCima1 = 0;
                    return;
                }
                else
                {
                    Volume = (1m / 3m) * (decimal)Math.PI * AlturaTopo1 * ((RaioBaseCima1 * RaioBaseCima1) + (RaioPescoço1 * RaioPescoço1) + (RaioPescoço1 * RaioBaseCima1))
                    VolumeAtual = VolumeAtual + Volume;
                    VolumeTotal1 = VolumeTotal1 - Volume;
                    AlturaTotal = AlturaTotal - AlturaTopo1;
                }*/
            }
        }

        private List<Preset> ReadPresetsFromFile()
        {
            List<Preset> presets = new List<Preset>();

            try
            {
                if (File.Exists("presets.json"))
                {
                    string json = File.ReadAllText("presets.json");
                    presets = JsonConvert.DeserializeObject<List<Preset>>(json);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro a ler os presets do ficheiro: {ex.Message}");
            }

            return presets;
        }

        private void SavePreset_Click(object sender, RoutedEventArgs e)
        {
            CalculateVolume_Click(this, null);

            if (Resultado.Content.ToString() == string.Empty)
            {
                return;
            }

            if (Resultado.Content == string.Empty)
            {
                MessageBox.Show("Faça os calculos primeiro!","Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (PresetTextBox.Text == string.Empty)
            {
                MessageBox.Show("Escreva um nome para o Preset!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            string presetName = PresetTextBox.Text;
            var newPresetValues = new Dictionary<string, string>
            {
                { "Diametro Pescoço", DiametroPescoçoTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(DiametroPescoçoTextBox.Text) ? DiametroPescoçoTextBox.Text : null },
                { "Altura Pequena Pescoço", AlturaPequenaPescoçoTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(AlturaPequenaPescoçoTextBox.Text) ? AlturaPequenaPescoçoTextBox.Text : null },
                { "Altura Grande Pescoço", AlturaGrandePescoçoTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(AlturaGrandePescoçoTextBox.Text) ? AlturaGrandePescoçoTextBox.Text : null },
                { "Angulo", AnguloTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(AnguloTextBox.Text) ? AnguloTextBox.Text : null },
                { "Hipotenusa", HipotenusaTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(HipotenusaTextBox.Text) ? HipotenusaTextBox.Text : null },
                { "Diametro Base", DiametroBaseTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(DiametroBaseTextBox.Text) ? DiametroBaseTextBox.Text : null },
                { "Altura Total", AlturaTotalTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(AlturaTotalTextBox.Text) ? AlturaTotalTextBox.Text : null },
                { "Hipotenusa Fundo", HipotenusaFundoTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(HipotenusaFundoTextBox.Text) ? HipotenusaFundoTextBox.Text : null },
                { "Diametro Pequeno Elipse", DiametroPequenoElipseTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(DiametroPequenoElipseTextBox.Text) ? DiametroPequenoElipseTextBox.Text : null },
                { "Diametro Grande Elipse", DiametroGrandeElipseTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(DiametroGrandeElipseTextBox.Text) ? DiametroGrandeElipseTextBox.Text : null },
                { "Espessura", EspessuraTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(EspessuraTextBox.Text) ? EspessuraTextBox.Text : null },
                { "Diametro Tubo", DiametroTuboTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(DiametroTuboTextBox.Text) ? DiametroTuboTextBox.Text : null },
                { "Comprimento Tubo", ComprimentoTuboTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(ComprimentoTuboTextBox.Text) ? ComprimentoTuboTextBox.Text : null },
                { "Altura Pescoço Adicional", AlturaPescoçoAdicionalTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(AlturaPescoçoAdicionalTextBox.Text) ? AlturaPescoçoAdicionalTextBox.Text : null },
                { "Diametro Pescoço Adicional", DiametroPescoçoAdicionalTextBox.Visibility == Visibility.Visible && !string.IsNullOrWhiteSpace(DiametroPescoçoAdicionalTextBox.Text) ? DiametroPescoçoAdicionalTextBox.Text : null },
            };

            // Remove entries with null values
            var filteredValues = newPresetValues.Where(pair => pair.Value != null)
                                                .ToDictionary(pair => pair.Key, pair => pair.Value);

            var newPreset = new Preset
            {
                PresetName = presetName,
                Options = new Dictionary<string, object>
                {
                    { "Base", CilindroBaseCheckBox.IsChecked == true ? "Cilindro" : "Cone" },
                    { "Pescoço", CentradoCheckBox.IsChecked == true ? "Centrado" : "Lado" },
                    { "Pescoço Adicional", PescoçoAdicionalSimCheckBox.IsChecked == true ? "True" : "False" },
                    { "Porta", PortaRetangularCheckBox.IsChecked == true ? "Retangulo" : "Elipse" },
                    { "PortaPosicao", PortaDentroCheckBox.IsChecked == true ? "Dentro" : "Fora" },
                    { "Fundo", FundoSimCheckBox.IsChecked == true ? "True" : "False" }
                },
                Values = filteredValues
            };

            string filePath = "presets.json";
            List<Preset> allPresets = new List<Preset>();

            // Read existing content if file exists
            if (File.Exists(filePath))
            {
                string existingJson = File.ReadAllText(filePath);

                // Deserialize existing presets
                allPresets = JsonConvert.DeserializeObject<List<Preset>>(existingJson);
            }

            // Vê se já existe algum preset com esse nome 
            if (allPresets.Any(p => p.PresetName == presetName))
            {
                MessageBoxResult result = MessageBox.Show($"Já Existe um preset com o nome '{presetName}'. Pretende substituir o antigo?.", "Erro", MessageBoxButton.YesNo, MessageBoxImage.Information);
                
                if (result == MessageBoxResult.Yes)
                {
                    RemoverPreset(allPresets);
                }
                else if (result == MessageBoxResult.No)
                {
                    return;
                }
            }

            // Add the new preset to the list
            allPresets.Add(newPreset);

            // Serialize and write back to the file
            string newJson = JsonConvert.SerializeObject(allPresets, Formatting.Indented);
            File.WriteAllText(filePath, newJson);

            BoxPresets.Items.Add(PresetTextBox.Text);

            BoxPresets.SelectedItem = null;
            PresetTextBox.Text = string.Empty;

            MessageBox.Show("Preset salvo com sucesso!");
        }

        private void BoxPresets_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (BoxPresets.SelectedItem != null)
            {
                List<Preset> presets = ReadPresetsFromFile();
                foreach (Preset item in presets)
                {
                    if (item.PresetName == BoxPresets.SelectedItem.ToString())
                    {
                        IsUpdating = true;

                        AlturaPequenaPescoçoTextBox.Text = item.Values["Altura Pequena Pescoço"].ToString();
                        DiametroPescoçoTextBox.Text = item.Values["Diametro Pescoço"].ToString();
                        DiametroBaseTextBox.Text = item.Values["Diametro Base"].ToString();
                        AlturaTotalTextBox.Text = item.Values["Altura Total"].ToString();
                        DiametroPequenoElipseTextBox.Text = item.Values["Diametro Pequeno Elipse"].ToString();
                        DiametroGrandeElipseTextBox.Text = item.Values["Diametro Grande Elipse"].ToString();
                        EspessuraTextBox.Text = item.Values["Espessura"].ToString();

                        if (item.Options["Pescoço"].ToString() == "Centrado")
                        {
                            HipotenusaTextBox.Text = item.Values["Hipotenusa"].ToString();
                            CentradoCheckBox.IsChecked = true;
                            NaoCentradoCheckBox.IsChecked = false;
                        }
                        else
                        {
                            AlturaGrandePescoçoTextBox.Text = item.Values["Altura Grande Pescoço"].ToString();
                            CentradoCheckBox.IsChecked = false;
                            NaoCentradoCheckBox.IsChecked = true;
                        }

                        if (item.Options["Porta"].ToString() == "Retangulo")
                        {
                            PortaRetangularCheckBox.IsChecked = true;
                            PortaOvalCheckBox.IsChecked = false;
                        }
                        else
                        {
                            PortaRetangularCheckBox.IsChecked = false;
                            PortaOvalCheckBox.IsChecked = true;
                        }

                        if (item.Options["PortaPosicao"].ToString() == "Dentro")
                        {
                            PortaDentroCheckBox.IsChecked = true;
                            PortaForaCheckBox.IsChecked = false;
                        }
                        else
                        {
                            PortaDentroCheckBox.IsChecked = false;
                            PortaForaCheckBox.IsChecked = true;
                        }

                        if (item.Options["Fundo"].ToString() == "True")
                        {
                            HipotenusaFundoTextBox.Text = item.Values["Hipotenusa Fundo"].ToString();
                            DiametroTuboTextBox.Text = item.Values["Diametro Tubo"].ToString();
                            ComprimentoTuboTextBox.Text = item.Values["Comprimento Tubo"].ToString();
                            FundoSimCheckBox.IsChecked = true;
                            FundoNaoCheckBox.IsChecked = false;
                        }
                        else
                        {
                            FundoSimCheckBox.IsChecked = false;
                            FundoNaoCheckBox.IsChecked = true;
                        }

                        if (item.Options["Base"].ToString() == "Cone")
                        {
                            AnguloTextBox.Text = item.Values["Angulo"].ToString();
                            ConeBaseCheckBox.IsChecked = true;
                            CilindroBaseCheckBox.IsChecked = false;
                        }
                        else
                        {
                            CilindroBaseCheckBox.IsChecked = true;
                            ConeBaseCheckBox.IsChecked = false;
                        }

                        if (item.Options["Pescoço Adicional"].ToString() == "True")
                        {
                            AlturaPescoçoAdicionalTextBox.Text = item.Values["Altura Pescoço Adicional"].ToString();
                            DiametroPescoçoAdicionalTextBox.Text = item.Values["Diametro Pescoço Adicional"].ToString();
                            PescoçoAdicionalSimCheckBox.IsChecked = true;
                            PescoçoAdicionalNaoCheckBox.IsChecked = false;
                        }
                        else
                        {
                            PescoçoAdicionalSimCheckBox.IsChecked = false;
                            PescoçoAdicionalNaoCheckBox.IsChecked = true;
                        }

                        IsUpdating = false;

                        CalculateVolume_Click(this, null);
                    }
                }
            }
        }
        private void LoadPresets()
        {
            if (File.Exists("presets.json"))
            {
                string existingJson = File.ReadAllText("presets.json");
                List<Preset> allPresets = JsonConvert.DeserializeObject<List<Preset>>(existingJson);

                BoxPresets.Items.Clear();
                foreach (var preset in allPresets)
                {
                    BoxPresets.Items.Add(preset.PresetName);
                }
            }
        }
        private void RemoverPreset_Click(object sender, RoutedEventArgs e)
        {
            if (BoxPresets.SelectedItem == null)
            {
                MessageBox.Show("Selecione um preset para remover.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            string selectedPresetName = BoxPresets.SelectedItem.ToString();

            if (File.Exists("presets.json"))
            {
                string existingJson = File.ReadAllText("presets.json");
                List<Preset> allPresets = JsonConvert.DeserializeObject<List<Preset>>(existingJson);

                var presetToRemove = allPresets.FirstOrDefault(p => p.PresetName == selectedPresetName);

                if (presetToRemove != null)
                {
                    allPresets.Remove(presetToRemove);
                    string newJson = JsonConvert.SerializeObject(allPresets, Formatting.Indented);
                    File.WriteAllText("presets.json", newJson);

                    MessageBox.Show("Preset removido com sucesso!");

                    Resultado.Content = string.Empty;
                    VolumePescoçoLabel.Content = string.Empty;
                    VolumeBaseLabel.Content = string.Empty;
                    VolumeFundoLabel.Content = string.Empty;
                    VolumeTopoLabel.Content = string.Empty;
                    VolumePortaLabel.Content = string.Empty;
                    ResultadoAtual.Content = string.Empty;
                    DiametroPescoçoTextBox.Text = string.Empty;
                    AlturaPequenaPescoçoTextBox.Text = string.Empty;
                    AlturaGrandePescoçoTextBox.Text = string.Empty;
                    AnguloTextBox.Text = string.Empty;
                    HipotenusaTextBox.Text = string.Empty;
                    DiametroBaseTextBox.Text = string.Empty;
                    AlturaTotalTextBox.Text = string.Empty;
                    HipotenusaFundoTextBox.Text = string.Empty;
                    DiametroPequenoElipseTextBox.Text = string.Empty;
                    DiametroGrandeElipseTextBox.Text = string.Empty;
                    EspessuraTextBox.Text = string.Empty;
                    DiametroTuboTextBox.Text = string.Empty;
                    ComprimentoTuboTextBox.Text = string.Empty;

                    CentradoCheckBox.IsChecked = true;
                    CilindroBaseCheckBox.IsChecked = true;
                    FundoNaoCheckBox.IsChecked = true;
                    PortaRetangularCheckBox.IsChecked = true;
                    PortaDentroCheckBox.IsChecked = true;

                    LoadPresets(); // Refresh the ComboBox

                    BoxPresets.SelectedItem = null;
                }
                else
                {
                    MessageBox.Show("Preset não encontrado.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            else
            {
                MessageBox.Show("Arquivo de presets não encontrado.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void RemoverPreset(List<Preset> allPresets)
        {
            string selectedPresetName = PresetTextBox.Text.Trim();
            MessageBox.Show("Preset a ser removido: " + selectedPresetName); // Mensagem de debug

            if (File.Exists("presets.json"))
            {
                try
                {
                    var presetToRemove = allPresets.FirstOrDefault(p => p.PresetName.Equals(selectedPresetName, StringComparison.OrdinalIgnoreCase));

                    if (presetToRemove != null)
                    {
                        allPresets.Remove(presetToRemove);
                        string newJson = JsonConvert.SerializeObject(allPresets, Formatting.Indented);
                        File.WriteAllText("presets.json", newJson);

                        MessageBox.Show("Preset removido com sucesso!");

                        LoadPresets(); // Refresh the ComboBox

                        BoxPresets.SelectedItem = null;
                    }
                    else
                    {
                        MessageBox.Show("Preset não encontrado.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro ao processar o arquivo de presets: {ex.Message}", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            else
            {
                MessageBox.Show("Arquivo de presets não encontrado.", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
