using System.Printing;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using MathNet.Numerics.Integration;

namespace ESGI181
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    /// 
    using System;
    using System.Globalization;
    using System.Windows.Data;

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

        public MainWindow()
        {
            InitializeComponent();
            CentradoCheckBox.IsChecked = true;
            ConeBaseCheckBox.IsChecked = true;
            FundoNaoCheckBox.IsChecked = true;
            PortaRetangularCheckBox.IsChecked = true;
            PortaForaCheckBox.IsChecked = true;

            DiametroPescoçoTextBox.Text = "60";
            AlturaPequenaPescoçoTextBox.Text = "30";
            AnguloTextBox.Text = "105";
            HipotenusaTextBox.Text = "65,5";
            DiametroBaseTextBox.Text = "245";
            AlturaTotalTextBox.Text = "232";
            DiametroPequenoElipseTextBox.Text = "41";
            DiametroGrandeElipseTextBox.Text = "50";
            EspessuraTextBox.Text = "6";
            AlturaCalcularVolumeTextBox.Text = "100";
        }

        private void CalculateVolume_Click(object sender, RoutedEventArgs e)
        {
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
                    decimal AlturaTopo = (decimal)Math.Sqrt((double)(Hipotenusa * Hipotenusa - cateto * cateto));

                    // Calcular o volume
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * AlturaPescoço;
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * AlturaTopo * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioPescoço * RaioPescoço) + (RaioPescoço * RaioBaixoTopo));

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

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    AlturaAux = AlturaGrandePescoço;

                    AlturaTopo1 = AlturaTopo;
                    AlturaPescoço1 = AlturaPescoço;

                    VolumePescoçoLabel.Content = (VolumePescoço / 1000m).ToString("F3");
                    VolumeTopoLabel.Content = (VolumeTopo / 1000m).ToString("F3");
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

                    decimal AlturaFundo = (decimal)Math.Sqrt((double)(HipotenusaFundo * HipotenusaFundo - cateto * cateto));

                    decimal AreaBaseTubo = (decimal)Math.PI * RaioTubo * RaioTubo;

                    // Calcular o volume do cone
                    decimal VolumeConeFundo = (1m / 3m) * (decimal)Math.PI * AlturaFundo * RaioBase * RaioBase;

                    decimal VolumeTuboFundo = AreaBaseTubo * ComprimentoTubo;

                    VolumeTotal = VolumeTotal + VolumeConeFundo + VolumeTuboFundo;

                    VFundo = VolumeConeFundo + VolumeTuboFundo;

                    VolumeFundoLabel.Content = ((VolumeConeFundo + VolumeTuboFundo) / 1000m).ToString("F3");
                }

                if (PortaOvalCheckBox.IsChecked == true)
                {
                    decimal RaioPequenoPorta = DiametroPequenoPorta / 2m;
                    decimal RaioGrandePorta = DiametroGrandePorta / 2m;

                    VolumePorta = ((decimal)Math.PI * RaioPequenoPorta * RaioGrandePorta) * Espessura;
                }

                if (PortaRetangularCheckBox.IsChecked == true)
                {
                    VolumePorta = DiametroPequenoPorta * DiametroGrandePorta * Espessura;
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
                if (ConeBaseCheckBox.IsChecked == true)
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
                    ResultadoAtual.Content = VolumeAtual / 1000m;
                    VolumeAtual = 0;
                    Volume = 0;
                    return;
                }
                else /*Feito*/
                {
                    Volume = (decimal)Math.PI * RaioBaseBaixo1 * RaioBaseBaixo1 * AlturaBase1;
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    Volume = 0;
                    VolumeTotal1 = VolumeTotal1 - VolumeAtual;
                    AlturaAtual = AlturaAtual - AlturaBase1;
                }
            }

            if (ConeBaseCheckBox.IsChecked == true)
            {
                if (AlturaBase1 >= AlturaAtual) /*Feito*/
                {
                    MessageBox.Show("Cima: " + RaioBaseCima1.ToString());
                    MessageBox.Show("Baixo: " + RaioBaseBaixo1.ToString());
                    decimal R = (RaioBaseBaixo1 - RaioBaseCima1);
                    MessageBox.Show("R: " + R.ToString());
                    MessageBox.Show("AlturaBase1: " + AlturaBase1.ToString());
                    MessageBox.Show("(R / AlturaBase1): " + (R / AlturaBase1).ToString());
                    decimal r = RaioBaseBaixo1 - (AlturaAtual * (R / AlturaBase1));
                    MessageBox.Show("r: " + r.ToString());
                    decimal VAux = (RaioBaseBaixo1 * RaioBaseBaixo1) + (r * r) + (RaioBaseBaixo1 * r);
                    MessageBox.Show("VAux: " + VAux.ToString());
                    Volume = (1m / 3m) * (decimal)Math.PI * AlturaAtual * VAux;
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    ResultadoAtual.Content = VolumeAtual / 1000m;
                    VolumeAtual = 0;
                    Volume = 0;
                    return;
                }
                else /*Feito*/
                {
                    Volume = (1m / 3m) * (decimal)Math.PI * (AlturaBase1) * ((RaioBaseBaixo1 * RaioBaseBaixo1) + (RaioBaseCima1 * RaioBaseCima1) + (RaioBaseCima1 * RaioBaseBaixo1));
                    VolumeAtual = VolumeAtual + VFundo + Volume + Porta;
                    Volume = 0;
                    VolumeTotal1 = VolumeTotal1 - VolumeAtual;
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
                    ResultadoAtual.Content = VolumeAtual / 1000m;
                    VolumeAtual = 0;
                    return;
                }
                else /*Feito*/
                {
                    decimal VAux = (RaioBaseCima1 * RaioBaseCima1) + (RaioPescoço1 * RaioPescoço1) + (RaioBaseCima1 * RaioPescoço1);
                    Volume = (1m / 3m) * (decimal)Math.PI * AlturaTopo1 * VAux;

                    VolumeAtual = VolumeAtual + Volume;
                    VolumeTotal1 = VolumeTotal1 - Volume;
                    Volume = 0;
                    AlturaAtual = AlturaAtual - AlturaTopo1;

                    Volume = (decimal)Math.PI * RaioPescoço1 * RaioPescoço1 * AlturaAtual;

                    VolumeAtual = VolumeAtual + Volume;
                    Volume = 0;
                    ResultadoAtual.Content = VolumeAtual / 1000m;
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
    }
}
