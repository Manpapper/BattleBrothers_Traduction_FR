this.goblin_land_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.goblin_land";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Vous trouvez un gobelin mort. Mais ce n\'est pas un gobelin ordinaire, c\'est un ancien. Il ou elle montre des signes de vieillesse. Il y a aussi des babioles de cérémonie sur lui. Ce gobelin n\'est pas arrivé ici par accident : il est mort et a reçu un enterrement digne de ce nom. Ce qui ne signifie qu\'une chose : vous êtes sur le territoire de ces maudites Peaux-Vertes. | Vous tombez sur un chien mort sur une colline. Sa langue pend, ses yeux sont presque prêts à sortir du crâne. Plusieurs fléchettes sortent de sa fourrure. %randombrother% en prend une et regarde les pointes de métal.%SPEECH_ON%Du poison Goblin.%SPEECH_OFF%Vous demandez pourquoi le chien. L\'homme hausse les épaules.%SPEECH_ON%Un chien effrayé fait un bon exercice de tir, je suppose.%SPEECH_OFF% | Une couronne de fleurs étranges et décolorées, de mauvaises herbes et de branches d\'arbres. Parmi elles, des douzaines de gros scarabées cliquettent lorsque leurs carapaces se heurtent les unes aux autres. Ils semblent se régaler de la sève ou de toute autre bizarrerie suintant de la collection végétale. Le frère aîné s\'interroge à voix haute.%SPEECH_ON%Je crois que j\'en ai déjà vu un comme ça avant. C\'est une sorte de marquage.%SPEECH_OFF%Vous le regardez.%SPEECH_ON%Nous devons garder un oeil ouvert pour des vieilles femmes qui s\'ennuient ou quelque chose comme ça ?%SPEECH_OFF%L\'homme secoue la tête.%SPEECH_ON%Non. C\'est la fabrication de gobelins. Nous sommes sur leur territoire maintenant.%SPEECH_OFF% | Alors que vous marchez dans les terres, vous tombez sur un orc mort. Il semble presque indemne, comme si vous l\'aviez trouvé par hasard en train de dormir. Mais en regardant de plus près, vous apercevez une douzaine de petites fléchettes plantées dans son flanc. Vous regardez immédiatement ce qui vous entoure, puis vous vous tournez vers vos hommes.%SPEECH_ON%Faites attention, les gars, nous sommes en territoire gobelin maintenant.%SPEECH_OFF% | Vous trouvez un certain nombre de pierres disposées en cercle. Au milieu de cette bizarrerie se trouve un crâne humain dont le sommet a été découpé. À l\'intérieur du crâne se trouvent plusieurs éléments qui semblent être des dés et des os de poulet. De tels motifs chamaniques ne sont pas trouvés par hasard, vous êtes sur les terres des gobelins. | Vous tombez sur un cerf mort pris au piège. Il aurait toutes les caractéristiques d\'un piège ordinaire - un piège qui a pour but de tuer à l\'aide de pointes - si ce n\'était pour le poison placé en évidence sur les points. Un poison qui est unique à un seul groupe : les gobelins. Il vaut mieux marcher prudemment à partir de maintenant. | Un feu qui fume. Des bâtons et des pierres disposés pour ceci ou cela. Une armurerie debout garnie de sarbacanes. Des lames courbes. Et un petit loup mort avec une laisse autour du cou. Ayant observé ces preuves, vous informez rapidement les hommes des circonstances qui les attendent.%SPEECH_ON%C\'est le territoire des gobelins, les gars, et d\'après ce que je vois, ils ne sont pas loin non plus.%SPEECH_OFF% | Une portée de louveteaux morts. Leur mère au ventre ouvert est près d\'eux, un collier autour du cou. Il y a une ligne de sang qui s\'éloigne de la scène, des petits pas dans l\'herbe.%SPEECH_ON%Les gobelins ont obtenu plus de leurs montures.%SPEECH_OFF%%randombrother% est à vos côtés. Il montre les chiots du doigt.%SPEECH_ON%On dit que les gobos aiment les sauvages. Ils cherchent les portées les plus fraîches et ne prennent que les plus fortes.%SPEECH_OFF%Tout ce que vous entendez, c\'est que vous êtes en territoire gobelin. Vous conseillez aux hommes de garder un œil sur ce qui les entoure, de peur que les petits malins ne vous tombent dessus.} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Soyez sur vos gardes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		local myTile = this.World.State.getPlayer().getTile();
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.getTile().getDistanceTo(myTile) <= 10)
			{
				return;
			}
		}

		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements();
		local num = 0;

		foreach( s in goblins )
		{
			if (s.getTile().getDistanceTo(myTile) <= 8)
			{
				num = ++num;
			}
		}

		if (num == 0)
		{
			return;
		}

		this.m.Score = 20 * num;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

