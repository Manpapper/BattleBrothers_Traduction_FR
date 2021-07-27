this.all_naked_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.all_naked";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]En marchant, vous apercevez un compagnon de route qui se penche en avant, puis en arrière, puis en avant encore, tandis que sa main ne sait pas si elle doit le protéger du soleil ou s\'arrêter pour se laisser aveugler... Il secoue la tête et crache.%SPEECH_ON%J\'\avais entendu parler de vous. Un groupe d\'hommes sans pantalon dans une terre de malheur, comme si une petite blague du diable avait pris vie. Qu\'est-ce que vous êtes ?%SPEECH_OFF%Vous haussez les épaules et dites à l\'homme que, jusqu\'à présent, vous n\'avez aucun problème à affronter vos problèmes sans cuir, sans plaque ou sans tissu. Encore une fois, le voyageur secoue la tête et crache.%SPEECH_ON%Putain d\'enfer. Un homme qui se bat sans rien sur lui est plus nu que le jour où il est né! Je suppose que l\'ironie est que si nous - et je veux dire n\'importe qui - nous venons te trouver mort dans les champs, alors nous t\'habillerons probablement mieux pour la tombe que tu ne le fais maintenant. Ce qui ne devrait pas être difficile, vu que vous n\'êtes pas du tout habillé.%SPEECH_OFF%Avec un petit signe de la main, vous remerciez le voyageur pour ses bonnes paroles avant de poursuivre votre joyeuse marche.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Quelle belle journée!",
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
		if (this.World.getTime().Days < 14)
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

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
			{
				return;
			}
		}

		this.m.Score = 25;
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

