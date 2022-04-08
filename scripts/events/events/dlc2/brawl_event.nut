this.brawl_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.brawl";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous sortez pour pisser et vous êtes en train de vous soulager quand le vacarme du combat éclate derrière vous. Vous arrangez vos culottes et retournez au campement. Là, vous trouvez toute la compagnie engagée dans une bataille non pas contre un ennemi particulier, mais contre elle-même. Les mercenaires enjambent l'équipement, le feu de camp et les autres pour se frapper avec leurs poings et leurs coudes, se battre les uns contre les autres ou se plaquer au sol. Quiconque tombe se fait botter le cul, littéralement, jusqu'à ce que quelqu'un d'autre vienne distraire ceux qui donnent les coups de pied, puis celui qui était tombé se relève d'un bond et se jette à nouveau dans la mêlée. La bagarre s'apaise au fur et à mesure que les hommes réalisent que vous êtes là et qu'ils se mettent en rang comme si une réorganisation rapide serait une solution appropriée à leur comportement grossier.\n\n Secouant la tête, vous demandez ce qui l'a déclenché. Les hommes haussent les épaules. Aucun ne s'en souvient. Vous faites l'appel pour vous assurer que personne n'est mort. Vous leur dites ensuite de se serrer la main, en gardant un œil sur eux pendant qu'ils le font. Pas de mauvais sang. Il semble que c'était juste une petite dispute amusante, c'est tout.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rien de tel qu'une bonne bagarre, hein ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Il y a eu une bonne bagarre");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
				}
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 10)
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

