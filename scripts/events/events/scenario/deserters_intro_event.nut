this.deserters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.deserters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{De longues marches sur de vieilles bottes. De la neige ? Combattez. La pluie ? Combattre. Être chargé par une ligne de chevaux lourds ? Ramassez cette lance. Combattez. Battez-vous. Toujours se battre. Mais même les simplicités rongent. Demande des chaussettes, on te dit de les voler aux paysans. Demande un meilleur repas, on te donne ta portion par terre\n\n Les manières du soldat ne vous dérangent pas. Tuer ne vous dérange pas, ni la menace de mort. Le manque de respect des nobles, le manque de responsabilité des lieutenants qui vous jettent bravement dans le broyeur à viande, voilà ce qui sape la volonté. Ça et l\'ennui. L\'interminable ennui du néant, jour après jour après jour.\n\nC\'est un peu ironique que vous et trois autres déserteurs ayez abandonné le camp de guerre le jour où ils l\'ont fait. Un grand repas a été offert aux soldats. Une célébration de la victoire, comme ils l\'appelaient. Votre assiette était remplie à ras bord de denrées alimentaires. Des portions qui appartenaient aux hommes qui sont morts ce jour-là. Et vous avez mangé cette nourriture. Vous avez tout mangé. Puis vous avez pris vos sacs, vous avez fait le guet pour la soirée et vous avez simplement filé. Pour avoir organisé l\'évasion, trois autres déserteurs ont choisi de suivre votre commandement.\n\nVous vous êtes forgé votre propre voie en tant que mercenaire où le salaire serait au moins à la hauteur de la douleur. Mais d\'abord, vous devrez vous frayer un chemin vers d\'autres terres, car si vous restez ici longtemps, vous finirez sûrement au bout d\'une corde.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons prendre notre destin en main.",
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
		this.m.Title = "The Deserters";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

