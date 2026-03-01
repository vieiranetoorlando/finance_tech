import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../viewmodels/finance_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Inicia a busca de dados assim que a tela é montada
    Future.microtask(() => context.read<FinanceViewModel>().loadCurrencies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Stack(
        children: [
          // Fundo com Gradiente Profissional
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F2027), Color(0xFF203A43)],
              ),
            ),
          ),
          // Detalhe visual de iluminação (Blur Circle)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Finance Tech",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text(
                    "Dashboard de Cotações em Tempo Real",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  // --- 1. AVISO DE MODO OFFLINE ---
                  Consumer<FinanceViewModel>(
                    builder: (context, vm, child) {
                      if (vm.isOffline) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orangeAccent.withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off,
                                color: Colors.orangeAccent,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Modo Offline: Usando dados salvos",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // --- 2. BARRA DE PESQUISA (SEARCH BAR) ---
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        // CHAMA O FILTRO NA VIEWMODEL
                        context.read<FinanceViewModel>().filterCurrencies(
                          value,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Buscar moeda ou código...",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.cyanAccent,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- 3. LISTA DE MOEDAS COM REFRESH ---
                  Expanded(
                    child: Consumer<FinanceViewModel>(
                      builder: (context, vm, child) {
                        if (vm.errorMessage != null &&
                            vm.displayCurrencies.isEmpty) {
                          return Center(
                            child: Text(
                              vm.errorMessage!,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () => vm.loadCurrencies(),
                          color: Colors.cyanAccent,
                          backgroundColor: const Color(0xFF162C33),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: vm.isLoading
                                ? 6
                                : vm.displayCurrencies.length,
                            itemBuilder: (context, index) {
                              if (vm.isLoading) {
                                return _buildShimmerCard();
                              }
                              final currency = vm.displayCurrencies[index];
                              return GestureDetector(
                                onTap: () =>
                                    _showConvertModal(context, currency),
                                child: _buildGlassCard(currency),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Efeito de carregamento "Skeleton Screen"
  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // Card Estilizado Glassmorphism
  Widget _buildGlassCard(currency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.code,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        currency.name,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "R\$ ${currency.bid.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "${currency.pctChange > 0 ? '+' : ''}${currency.pctChange}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currency.pctChange > 0
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modal de Conversão
  void _showConvertModal(BuildContext context, currency) {
    final controller = TextEditingController();
    double result = 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              top: 20,
              left: 25,
              right: 25,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2027).withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "Converter ${currency.code}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    labelText: "Valor em Reais (R\$)",
                    labelStyle: const TextStyle(color: Colors.cyanAccent),
                    prefixIcon: const Icon(
                      Icons.currency_exchange,
                      color: Colors.cyanAccent,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white24),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (val) {
                    setModalState(() {
                      double input =
                          double.tryParse(val.replaceAll(',', '.')) ?? 0;
                      result = input / currency.bid;
                    });
                  },
                ),
                const SizedBox(height: 35),
                Text(
                  "Você teria aproximadamente:",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${currency.code} ${result.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
