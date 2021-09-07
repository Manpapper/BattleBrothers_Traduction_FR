this.ratcatcher_catches_food_event <- this.inherit("scripts/events/event", {
	m = {
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.ratcatcher_catches_food";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] Les rations étant réduites à néant, %ratcatcher% entre faiblement dans votre tente, les gémissements de quelques hommes affamés passant avant que les rideaux ne se referment derrière lui. Il vous explique qu\'il a une solution à votre problème de nourriture. Vous n\'osez pas demander de quoi il s\'agit, mais vous n\'avez plus le choix. Le ratchatcher balance un sac en toile de jute sur la table. Une partie de ce sac bouge, sautille, rebondit et couine. L\'homme le frappe avec son poing avant de vous sourire.%SPEECH_ON%Désolé, nous en avons un de vivace ici !%SPEECH_OFF%Il explique que le rat n\'est pas l\'animal le plus nourrissant, ni le plus sain, mais qu\'il aidera suffisamment la compagnie jusqu\'à ce qu\'elle puisse rejoindre une ville ou une ferme. Vous acceptez à contrecoeur d\'empêcher vos hommes de mourir de faim.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous n\'avons pas le choix...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				local food = this.new("scripts/items/supplies/strange_meat_item");
				food.setAmount(12);
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + food.getAmount() + "[/color] Viande de Rat"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Ratcatcher.getID())
					{
						continue;
					}

					if (bro.getBackground().isNoble())
					{
						bro.worsenMood(1.0, "Perte de confiance dans votre leadership");
						bro.worsenMood(2.0, "On lui a servi du rat pour le dîner");
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
					else
					{
						local r = this.Math.rand(1, 5);

						if (r == 1 && !bro.getBackground().isLowborn())
						{
							bro.worsenMood(1.0, "On lui a servi du rat pour le dîner");

							if (bro.getMoodState() < this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
						else if (r == 2 && !bro.getSkills().hasSkill("injury.sickness"))
						{
							local effect = this.new("scripts/skills/injury/sickness_injury");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " est malade"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() > 15)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Ratcatcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Ratcatcher = null;
	}

});

