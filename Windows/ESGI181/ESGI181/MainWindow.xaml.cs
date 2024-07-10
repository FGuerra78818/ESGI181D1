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

namespace ESGI181
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            CentradoCheckBox.IsChecked = true;
            ConeTopoCheckBox.IsChecked = true;
            CilindroBaseCheckBox.IsChecked = true;
            FundoNaoCheckBox.IsChecked = true;
            PortaRetangularCheckBox.IsChecked = true;
            PortaDentroCheckBox.IsChecked = true;
        }

        private void CalculateVolume_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                decimal VolumeTotal = 0;
                decimal DiametroPescoço = decimal.Parse(DiametroPescoçoTextBox.Text);
                decimal RaioPescoço = DiametroPescoço / 2m;
                decimal AlturaPescoço = decimal.Parse(AlturaPequenaPescoçoTextBox.Text);
                decimal AlturaPequenaPescoço = decimal.Parse(AlturaPequenaPescoçoTextBox.Text);
                decimal DiametroBase = decimal.Parse(DiametroBaseTextBox.Text);
                decimal RaioBase = DiametroBase / 2m;
                decimal DiametroPequenoPorta = decimal.Parse(DiametroPequenoElipseTextBox.Text);
                decimal DiametroGrandePorta = decimal.Parse(DiametroGrandeElipseTextBox.Text);
                decimal Espessura = decimal.Parse(EspessuraTextBox.Text);
                decimal VolumePorta = 0;
                decimal RaioBaixoTopo = 0;

                if (ConeBaseCheckBox.IsChecked == true)
                {
                    decimal Hipotenusa = decimal.Parse(AlturaBaseTextBox.Text);

                    decimal cateto = (RaioBase - RaioBaixoTopo);
                    decimal AlturaBase = (decimal)Math.Sqrt((double)(Hipotenusa * Hipotenusa - cateto * cateto));

                    RaioBaixoTopo = decimal.Parse(DiametroBaixoTopoTextBox.Text) / 2m;

                    // Calcular a area da base
                    decimal AreaBase = (1m / 3m) * (decimal)Math.PI * AlturaBase * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioPescoço * RaioPescoço) + (RaioPescoço * RaioBaixoTopo));

                    // Calcular o volume do cone
                    decimal VolumeBase = (1 / 3) * (decimal)Math.PI * RaioBase * RaioBase * AlturaBase;
                    VolumeTotal = VolumeTotal + VolumeBase;

                    VolumeBaseLabel.Content = (VolumeBase / 1000m).ToString("F3");
                }

                if (CilindroBaseCheckBox.IsChecked == true)
                {
                    decimal AlturaBase = decimal.Parse(AlturaBaseTextBox.Text);

                    // Calcular a area da base
                    decimal AreaBase = (decimal)Math.PI * RaioBase * RaioBase;

                    // Calcular o volume do cilindro
                    decimal VolumeBase = AreaBase * AlturaBase;
                    VolumeTotal = VolumeTotal + VolumeBase;

                    RaioBaixoTopo = RaioBase;

                    VolumeBaseLabel.Content = (VolumeBase / 1000m).ToString("F3");
                }

                if (CentradoCheckBox.IsChecked == true && ConeTopoCheckBox.IsChecked == true)
                {
                    decimal Hipotenusa = decimal.Parse(HipotenusaTextBox.Text);
                    decimal cateto = (RaioBaixoTopo - RaioPescoço);
                    decimal AlturaTopo = (decimal)Math.Sqrt((double)(Hipotenusa * Hipotenusa - cateto * cateto));

                    // Calcular o volume
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * AlturaPescoço;
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * AlturaTopo * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioPescoço * RaioPescoço) + (RaioPescoço * RaioBaixoTopo));

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    VolumePescoçoLabel.Content = (VolumePescoço / 1000m).ToString("F3");
                    VolumeTopoLabel.Content = (VolumeTopo / 1000m).ToString("F3");
                }

                if (NaoCentradoCheckBox.IsChecked == true && ConeTopoCheckBox.IsChecked == true)
                {
                    decimal AlturaGrandePescoço = decimal.Parse(AlturaGrandePescoçoTextBox.Text);

                    // Calcular o volume
                    decimal AlturaTopo = (RaioBaixoTopo * (AlturaGrandePescoço - AlturaPequenaPescoço)) / (RaioPescoço * 2);
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * ((AlturaGrandePescoço + AlturaPequenaPescoço) / 2m);
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * RaioBaixoTopo * RaioBaixoTopo * AlturaTopo;

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    VolumePescoçoLabel.Content = (VolumePescoço / 1000m).ToString("F3");
                    VolumeTopoLabel.Content = (VolumeTopo / 1000m).ToString("F3");
                }

                if (FundoSimCheckBox.IsChecked == true)
                {
                    decimal HipotenusaFundo = decimal.Parse(HipotenusaFundoTextBox.Text);
                    decimal DiametroTubo = decimal.Parse(DiametroTuboTextBox.Text);
                    decimal RaioTubo = DiametroTubo / 2m;
                    decimal ComprimentoTubo = decimal.Parse(ComprimentoTuboTextBox.Text);

                    decimal cateto = (RaioBase - RaioTubo);

                    decimal AlturaFundo = (decimal)Math.Sqrt((double)(HipotenusaFundo * HipotenusaFundo - cateto * cateto));


                    // Calcular a area da base
                    decimal AreaBase = (decimal)Math.PI * RaioBase * RaioBase;

                    decimal AreaBaseTubo = (decimal)Math.PI * RaioBase * RaioBase;

                    // Calcular o volume do cone
                    decimal VolumeTroncoFundo = (1m / 3m) * (decimal)Math.PI * AlturaFundo * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioPescoço * RaioPescoço) + (RaioPescoço * RaioBaixoTopo));

                    decimal VolumeTuboFundo = AreaBaseTubo * ComprimentoTubo;

                    VolumeTotal = VolumeTotal + VolumeTroncoFundo + VolumeTuboFundo;

                    VolumeFundoLabel.Content = ((VolumeTroncoFundo + VolumeTuboFundo) / 1000m).ToString("F3");
                }

                if (PortaOvalCheckBox.IsChecked == true)
                {
                    decimal RaioPequenoPorta = DiametroPequenoPorta / 2m;
                    decimal RaioGrandePorta = DiametroGrandePorta / 2m;

                    VolumePorta = ((decimal)Math.PI * RaioPequenoPorta * RaioGrandePorta) * Espessura;
                }

                if (PortaRetangularCheckBox.IsChecked == true)
                {
                    VolumePorta = RaioPequenoPorta * RaioGrandePorta * Espessura;
                }

                if (PortaDentroCheckBox.IsChecked == true)
                {
                    VolumeTotal = VolumeTotal - VolumePorta;

                    VolumePortaLabel.Content = (VolumePorta / 1000m).ToString("F3");
                }
                else
                {
                    VolumeTotal = VolumeTotal + VolumePorta;

                    VolumePortaLabel.Content = (VolumePorta / 1000m).ToString("F3");
                }
                Resultado.Content = (VolumeTotal / 1000m).ToString("F3");
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

            if ((sender == ConeTopoCheckBox || sender == ParabolaTopoCheckBox) && (ConeTopoCheckBox.IsChecked == false) && (ParabolaTopoCheckBox.IsChecked == false))
            {
                ConeTopoCheckBox.IsChecked = true;
            }
            if (sender == ConeTopoCheckBox && ConeTopoCheckBox.IsChecked == true)
            {
                ParabolaTopoCheckBox.IsChecked = false;
            }
            else if (sender == ParabolaTopoCheckBox && ParabolaTopoCheckBox.IsChecked == true)
            {
                ConeTopoCheckBox.IsChecked = false;
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
                DiametroBaixoTopo.Visibility = Visibility.Collapsed;
                DiametroBaixoTopoTextBox.Visibility = Visibility.Collapsed;
                AlturaBase.Content = "Altura Base (A):";
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
                DiametroBaixoTopo.Visibility = Visibility.Collapsed;
                DiametroBaixoTopoTextBox.Visibility = Visibility.Collapsed;
                AlturaBase.Content = "Altura Base (A):";
            }
            else if (sender == ConeBaseCheckBox && ConeBaseCheckBox.IsChecked == true)
            {
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
                DiametroBaixoTopo.Visibility = Visibility.Visible;
                DiametroBaixoTopoTextBox.Visibility = Visibility.Visible;
                AlturaBase.Content = "Hipotenusa Base (H):";
            }

            /*---------------------------------------------------*/

            if ((sender == FundoSimCheckBox || sender == FundoNaoCheckBox) && (FundoSimCheckBox.IsChecked == false) && (FundoNaoCheckBox.IsChecked == false))
            {
                FundoNaoCheckBox.IsChecked = true;
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
    }
}
