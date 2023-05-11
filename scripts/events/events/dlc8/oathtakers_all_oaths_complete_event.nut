this.oathtakers_all_oaths_complete_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oathtakers_all_oaths_complete";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Les derniers serments du Jeune Anselm sont terminés. Les Oathtakers ont vraiment mérité leur nom! Il ne reste plus qu\'une question: Et maintenant? Vous n\'avez jamais été certain de ce qui se passerait une fois que les serments du premier Oathtaker auraient été accomplis, mais maintenant que c\'est fait, quelque chose vous frappe, vous et le reste de la compagnie: poursuivre. Pourquoi faire demi-tour maintenant? Qui veut retourner à son ancienne vie, sans but, moribonde et apathique? Ce n\'est sûrement pas ce que le jeune Anselm voulait en s\'engageant sur le Chemin Final. Vous dites aux hommes que chaque serment a sa signification, et peut-être que ce sont tous les serments mis bout à bout qui forment une signification qui leur est propre. Le chemin du Oathtaker se termine lorsqu\'il le souhaite. Vous regardez la bande.%SPEECH_ON%Si vous vous croyez libéré de l\'obligation de prêter serment, alors partez, s\'il vous plaît.%SPEECH_OFF%Une vague de regards pensifs s\'abat sur le groupe. Finalement, l\'un d\'eux s\'exclame.%SPEECH_ON%Il n\'y a qu\'une seule façon de quitter la voie du Jeune Anselm, c\'est de le rejoindre!%SPEECH_OFF%Le groupe applaudit. Au jeune Anselm, à la découverte de sa mâchoire et à la mort de tous les Oathbringers!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Au jeune Anselm!",
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
					bro.improveMood(2.0, "Completed all of Young Anselm\'s oaths");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}

					bro.getBaseProperties().Bravery += 1;
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local all_oaths_complete = this.World.Ambitions.getAmbition("ambition.oath_of_camaraderie").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_distinction").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_dominion").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_endurance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_fortification").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_honor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_humility").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_righteousness").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_sacrifice").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_valor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_vengeance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_wrath").isDone();

		if (!all_oaths_complete)
		{
			return;
		}

		this.m.Score = 600;
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

