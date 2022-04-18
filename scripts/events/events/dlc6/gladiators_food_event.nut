this.gladiators_food_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.gladiators_food";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_155.png[/img]{Les Gladiateurs demandent une meilleure nourriture. Je suis désolé, capitaine, mais qu\'est-ce que tu veux que je fasse avec ça ? Les Gladiateurs montrent une miche de pain. Où est la viande ? Regarde-la. REGARDE. Regarde. Qui a fait ça ? Un boulanger ? Tu veux que je mange le pain d\'un boulanger ? Je veux manger ce qui se défend. Est-ce que le pain se défend ? Je ne pense pas. Il semble que les Gladiateurs soient loin de l\'arène, mais pas loin du traitement de faveur que les chefs leur accordent jour après jour. Peut-être devriez-vous chercher une variété de nourriture de haute qualité pour les faire taire. | %SPEECH_START% Où sont les bonnes choses, hein ? %SPEECH_OFF%%gl% tend un morceau de repas. Il se retourne et jette la nourriture qui tape contre le côté du wagon de la compagnie où elle se décolle et se recroqueville comme un crochet à l\'envers.%SPEECH_ON% Nous exigeons de la bonne nourriture, capitaine ! Nous exigeons de la bonne nourriture, capitaine ! Pas de cette merde de gibier.%SPEECH_OFF% Vous devriez probablement chercher à donner aux gladiateurs de la nourriture qui soit plus conforme à leurs normes. | Où est le vin ? Où sont les charcuteries!%SPEECH_OFF%%gl% prend son assiette de nourriture et la lance comme un disque. Il va très loin, les morceaux de nourriture sont projetés dans un cône de débris caloriques.%SPEECH_ON% J\'exige des charcuteries, capitaine ! Où sont mes charcuteries ? Il semble que les gladiateurs exigent une nourriture de meilleure qualité.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu m\'as déjà coûté une fortune !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
					{
						bro.worsenMood(1.5, "Demande une meilleure alimentation");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasExquisiteFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getRawValue() >= 85)
				{
					hasExquisiteFood = true;
					break;
				}
			}
		}

		if (hasExquisiteFood)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 40;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gl",
			this.m.Gladiator != null ? this.m.Gladiator.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
	}

});

