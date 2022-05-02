this.unhold_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.unhold_exposition";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_126.png[/img]{Un vieil homme dessine sur un rocher avec de la craie. Il regarde la compagnie comme si c\'était une distraction pour son art, mais quand on passe sur le côté, on voit qu\'il a peint ce qui ressemble à des géants dominant des tribus d\'hommes. Tapant la craie sur la roche, il parle comme s\'il était en train de donner une leçon.%SPEECH_ON%Je parie que les unhold sont ici depuis plus longtemps que n\'importe quel homme. Savez-vous qu\'il y a des sortes qui vivent dans les froids, d\'autres dans les forêts, et d\'autres encore dans les marais ? Et aucun d\'entre eux n\'a d\'affinités avec les autres. C\'est l\'homme dans ses instincts les plus basiques, destructeur et rancunier envers ses semblables, mais la plupart de son animosité est dirigée contre une chose en particulier.%SPEECH_OFF%Le vieil homme pointe la craie vers vous et incline son extrémité de façon à ce que de la poudre s\'échappe de son bout.%SPEECH_ON%Les étrangers. Ne vous approchez pas des unholds, voyageurs.%SPEECH_OFF%Il ne semble pas très bien dans sa tête et n\'a rien d\'intéressant à voler, si ce n\'est de la craie, alors vous faites avancer la compagnie. | Un jeune enfant est trouvé en train de dessiner dans la boue du chemin. En vous approchant, vous réalisez qu\'il n\'est pas vraiment sur le chemin, mais plutôt à l\'intérieur d\'une grande motte où la boue a pris la forme et la taille d\'un sarcophage. L\'enfant dessine le long des parois intérieures, principalement des formes grossières de chiens.%SPEECH_ON%Mon père disait que c\'était des \"unholds\", des unholds qui venaient d\'ici et d\'ailleurs, des géants de légende, sauf qu\'ils étaient \"aussi réels que ta mère qui me quitte pour ce bâtard de Birk, que je vais tuer\", il dit souvent ça. Birk l\'a bien cherché. C\'est ce qu\'il dit. Souvent. Je pense que vous devriez rester loin des unholds, monsieur. Mon père le dit, alors je le ferai aussi, et vous devriez aussi. Au fait, vous vous appelez Birk ?%SPEECH_OFF%Vous secouez la tête pour dire non et souhaitez le meilleur à l\'enfant. À bien des égards, vous pensez que ce qu\'il a dit était un conseil assez juste de la part d\'un enfant. | Un vieil homme au corps de pierre vous regarde depuis le porche de la maison.%SPEECH_ON%Vous savez, une fois j\'ai vu un unhold en personne. C\'est vrai. Un vrai géant, de la taille de dix hommes empilés, si ce n\'est plus. Il errait dans les steppes, chassant les chevaux et autres. Ils ont envoyé une milice à sa poursuite et cette foutue chose les a balancés comme des poupées. Elle a soulevé un homme et l\'a jeté si fort que j\'ai cru qu\'il allait voler au-dessus des montagnes. Vous semblez être du genre combatif, alors croyez-en mon vieux, restez loin de ces unholds.%SPEECH_OFF%Vous hochez la tête et souhaitez le meilleur à l\'aîné.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelqu\'un devrait nous payer pour que nous nous en occupions.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Tundra)
		{
			return;
		}

		this.m.Score = 5;
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

