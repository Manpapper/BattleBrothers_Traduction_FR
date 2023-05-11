this.paladins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.paladins_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Vous connaissiez bien le jeu et, comme tout bon jeu, vous vous êtes lassé des règles et de ceux qui les établissent. Des serments pour ceci, des serments pour cela. Tout ce que vous saviez, c\'est que vous n\'aviez jamais pu tenir le crâne du jeune Anselm, et que la dernière fois que vous l\'aviez vu, un certain prêteur de serments s\'était emparé du crâne du jeune homme. Quitter les prêteurs de serments a été la meilleure décision que vous ayez jamais prise, ne serait-ce que pour préserver le peu de santé mentale qu\'il vous restait.\n\nMalheureusement, les fidèles ont le nez fin pour sentir l\'odeur de l\'apostat. Lorsque vous avez ouvert la porte ce matin, vous avez eu l\'impression de voir deux tas de merde qu\'un gamin farceur vous avait laissés : %oathtaker1% et %oathtaker2%, en chair et en os. Le premier est un homme d\'un certain âge qui ne s\'est jamais détourné de ses convictions, et le second est un écuyer talentueux qui vous rappelle vous-même. Sans doute le plus bavard, c\'est le plus jeune qui a plaidé sa cause : les prêteurs de serments ont besoin d\'un homme connaissant bien la terre pour les aider à se déplacer, à accomplir des quêtes et à prêter serment. En refermant la porte, vous vous apercevez que l\'aîné y a mis le pied. Il a porte un tas d\'or, et votre nez a dû se froncer ou s\'agiter, car les deux hommes se sont illuminés.\n\nVous n\'y allez que parce que les temps sont durs et que le mercenariat - même sous couvert de devoir religieux - peut rapporter beaucoup d\'argent. Et si quelqu\'un est prêt à vous financer pour une tâche aussi opulente, qu\'il en soit ainsi. Il n\'y a qu\'une seule condition : vous devez prêter le serment de capitaine, ce qui signifie que tous les combats et toutes les rudes épreuves seront accomplis par d\'autres. Les preneurs de serment acceptent sans hésiter, puis ils vous montrent le crâne du jeune Anselm. Vous avez perdu le contact avec l\'organisation, mais voir le crâne de ce gaillard vous fait encore chaud au cœur. %oathtaker2% acquiesce.%SPEECH_ON%Parcourons ces terres à la recherche de personnes honorables, soyons diligents dans nos tâches, et puissions-nous un jour rendre au jeune Anselm la santé qu\'il avait perdue à cause des bâtards de prêteurs de serments qui l\'ont brisé !%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pour l\'or, la gloire et le jeune Anselm !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Les Prêteurs de Serments";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"oathtaker1",
			brothers[0].getName()
		]);
		_vars.push([
			"oathtaker2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});

