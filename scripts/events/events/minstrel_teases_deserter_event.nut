this.minstrel_teases_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Deserter = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_teases_deserter";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] Alors que le feu de camp crépite, %minstrel% le ménestrel se lève et se tient haut sur sa souche. Il se frappe la poitrine puis désigne %déserteur%.%SPEECH_ON%Oui, toi l\'homme aux pieds si fuyants, aux pieds qui s\'enfuient avant d\'avoir été battus ! Le déserteur ! Oh, le déserteur ! Un dessert pour le déserteur ! Son courage, il l\'a étrillé, son honneur, il l\'a bafoué, sa virilité, il l\'a assassiné ! Le déserteur!%SPEECH_OFF% D\'un geste rapide, le ménestrel frappe dans ses mains et se laisse retomber sur son siège. Il n\'y reste qu\'un instant avant que les mains de %deserter% ne se referment sur son cou. La compagnie est en ébullition, coincée entre la séparation des deux et la crise de fou rire.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une épopée pour toutes les mauvaises raisons !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Deserter.getImagePath());
				_event.m.Deserter.worsenMood(2.0, "S\'est senti humilié devant la compagnie.");

				if (_event.m.Deserter.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Deserter.getMoodState()],
						text = _event.m.Deserter.getName() + this.Const.MoodStateEvent[_event.m.Deserter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_minstrel = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		local candidates_deserter = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.deserter")
			{
				candidates_deserter.push(bro);
			}
		}

		if (candidates_deserter.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Deserter = candidates_deserter[this.Math.rand(0, candidates_deserter.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_deserter.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"deserter",
			this.m.Deserter.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Deserter = null;
	}

});

