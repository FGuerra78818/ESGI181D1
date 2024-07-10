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
                decimal AlturaBase = decimal.Parse(AlturaBaseTextBox.Text);
                decimal DiametroPequenoPorta = decimal.Parse(DiametroPequenoElipseTextBox.Text);
                decimal RaioPequenoPorta = DiametroPequenoPorta / 2m;
                decimal DiametroGrandePorta = decimal.Parse(DiametroGrandeElipseTextBox.Text);
                decimal RaioGrandePorta = DiametroGrandePorta / 2m;
                decimal Espessura = decimal.Parse(EspessuraTextBox.Text);
                decimal VolumePorta = 0;
                decimal RaioBaixoTopo = 0;

                if (ConeBaseCheckBox.IsChecked == true)
                {
                    RaioBaixoTopo = decimal.Parse(DiametroBaixoTopoTextBox.Text) / 2m;

                    // Calcular a area da base
                    decimal AreaBase = (decimal)Math.PI * RaioBase * RaioBase;

                    // Calcular o volume do cone
                    decimal VolumeBase = (1 / 3) * (decimal)Math.PI * RaioBase * RaioBase * AlturaBase;
                    VolumeTotal = VolumeTotal + VolumeBase;

                    Resultado.Content = VolumeTotal;
                    MessageBox.Show("Cone Base");
                }

                if (CilindroBaseCheckBox.IsChecked == true)
                {
                    // Calcular a area da base
                    decimal AreaBase = (decimal)Math.PI * RaioBase * RaioBase;

                    // Calcular o volume do cilindro
                    decimal VolumeBase = AreaBase * AlturaBase;
                    VolumeTotal = VolumeTotal + VolumeBase;

                    RaioBaixoTopo = RaioBase;

                    Resultado.Content = VolumeTotal;
                    MessageBox.Show("Cilindro Base");
                }

                if (CentradoCheckBox.IsChecked == true && ConeTopoCheckBox.IsChecked == true)
                {
                    decimal Hipotenusa = decimal.Parse(HipotenusaTextBox.Text);
                    decimal cateto = (RaioBaixoTopo - RaioPescoço);
                    MessageBox.Show(cateto.ToString());
                    decimal AlturaTopo = (decimal)Math.Sqrt((double)(Hipotenusa * Hipotenusa - cateto * cateto));
                    MessageBox.Show(AlturaTopo.ToString());

                    // Calcular o volume
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * AlturaPescoço;
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * AlturaTopo * ((RaioBaixoTopo * RaioBaixoTopo) + (RaioPescoço * RaioPescoço) + (RaioPescoço * RaioBaixoTopo));

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    Resultado.Content = VolumePescoço + VolumeTopo;
                    MessageBox.Show("Cone Topo e Centrado");
                }

                if (NaoCentradoCheckBox.IsChecked == true && ConeTopoCheckBox.IsChecked == true)
                {
                    decimal AlturaGrandePescoço = decimal.Parse(AlturaGrandePescoçoTextBox.Text);

                    // Calcular o volume
                    decimal AlturaTopo = (RaioBaixoTopo * (AlturaGrandePescoço - AlturaPequenaPescoço)) / (RaioPescoço * 2);
                    decimal VolumePescoço = (decimal)Math.PI * RaioPescoço * RaioPescoço * ((AlturaGrandePescoço + AlturaPequenaPescoço) / 2m);
                    decimal VolumeTopo = (1m / 3m) * (decimal)Math.PI * RaioBaixoTopo * RaioBaixoTopo * AlturaTopo;

                    VolumeTotal = VolumeTotal + VolumePescoço + VolumeTopo;

                    Resultado.Content = VolumePescoço + VolumeTopo;
                    MessageBox.Show("Cone Topo e Não Centrado");
                }

                if (FundoSimCheckBox.IsChecked == true)
                {
                    decimal AlturaFundo = decimal.Parse(AlturaFundoTextBox.Text);

                    // Calcular a area da base
                    decimal AreaBase = (decimal)Math.PI * RaioBase * RaioBase;

                    // Calcular o volume do cone
                    decimal VolumeFundo = (1 / 3) * (decimal)Math.PI * RaioBase * RaioBase * AlturaFundo;
                    VolumeTotal = VolumeTotal + VolumeFundo;

                    Resultado.Content = VolumeFundo;
                    MessageBox.Show("Fundo");
                }

                if (PortaOvalCheckBox.IsChecked == true)
                {
                    VolumePorta = ((decimal)Math.PI * RaioPequenoPorta * RaioGrandePorta) * Espessura;

                    MessageBox.Show("Porta Oval");
                }

                if (PortaRetangularCheckBox.IsChecked == true)
                {
                    VolumePorta = RaioPequenoPorta * RaioGrandePorta * Espessura;

                    MessageBox.Show("Porta Retangular");
                }

                if (PortaDentroCheckBox.IsChecked == true)
                {
                    VolumeTotal = VolumeTotal - VolumePorta;

                    Resultado.Content = VolumePorta;
                    MessageBox.Show("Porta Dentro");
                }
                else
                {
                    VolumeTotal = VolumeTotal + VolumePorta;

                    Resultado.Content = VolumePorta;
                    MessageBox.Show("Porta Fora");
                }
                Resultado.Content = VolumeTotal;
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
                AlturaPequenaPescoço.Content = "Altura Pescoço (a)";
                AlturaGrandePescoço.Visibility = Visibility.Collapsed;
                AlturaGrandePescoçoTextBox.Visibility = Visibility.Collapsed;
                Hipotenusa.Visibility = Visibility.Visible;
                HipotenusaTextBox.Visibility = Visibility.Visible;
            }
            if (sender == CentradoCheckBox && CentradoCheckBox.IsChecked == true)
            {
                NaoCentradoCheckBox.IsChecked = false;
                AlturaPequenaPescoço.Content = "Altura Pescoço (a)";
                AlturaGrandePescoço.Visibility = Visibility.Collapsed;
                AlturaGrandePescoçoTextBox.Visibility = Visibility.Collapsed;
                Hipotenusa.Visibility = Visibility.Visible;
                HipotenusaTextBox.Visibility = Visibility.Visible;
            }
            else if (sender == NaoCentradoCheckBox && NaoCentradoCheckBox.IsChecked == true)
            {
                CentradoCheckBox.IsChecked = false;
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
                DiametroBaixoTopo.Visibility = Visibility.Collapsed;
                DiametroBaixoTopoTextBox.Visibility = Visibility.Collapsed;
            }
            if (sender == CilindroBaseCheckBox && CilindroBaseCheckBox.IsChecked == true)
            {
                ConeBaseCheckBox.IsChecked = false;
                DiametroBaixoTopo.Visibility = Visibility.Collapsed;
                DiametroBaixoTopoTextBox.Visibility = Visibility.Collapsed;
            }
            else if (sender == ConeBaseCheckBox && ConeBaseCheckBox.IsChecked == true)
            {
                CilindroBaseCheckBox.IsChecked = false;
                DiametroBaixoTopo.Visibility = Visibility.Visible;
                DiametroBaixoTopoTextBox.Visibility = Visibility.Visible;
            }

            /*---------------------------------------------------*/

            if ((sender == FundoSimCheckBox || sender == FundoNaoCheckBox) && (FundoSimCheckBox.IsChecked == false) && (FundoNaoCheckBox.IsChecked == false))
            {
                FundoNaoCheckBox.IsChecked = true;
                AlturaFundo.Visibility = Visibility.Collapsed;
                AlturaFundoTextBox.Visibility = Visibility.Collapsed;
            }
            if (sender == FundoSimCheckBox && FundoSimCheckBox.IsChecked == true)
            {
                FundoNaoCheckBox.IsChecked = false;
                AlturaFundo.Visibility = Visibility.Visible;
                AlturaFundoTextBox.Visibility = Visibility.Visible;
            }
            else if (sender == FundoNaoCheckBox && FundoNaoCheckBox.IsChecked == true)
            {
                FundoSimCheckBox.IsChecked = false;
                AlturaFundo.Visibility = Visibility.Collapsed;
                AlturaFundoTextBox.Visibility = Visibility.Collapsed;
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