this.ratcatcher_spreads_disease_event <- this.inherit("scripts/events/event", {
	m = {
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.ratcatcher_spreads_disease";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_18.png[/img]%ratcatcher% le chasseur de rat a mérité son ancien nom : apparemment, il a rassemblé des rats pendant que votre groupe se déplaçait. Ce soir, ils se sont tous échappés. Une partie des stocks de nourriture a dû être jetée et quelques hommes sont tombés malades.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ma gorge est si irritée que je peux à peine articuler un mot !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				local food = this.Math.rand(8, 18);
				this.World.Assets.removeRandomFood(food);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_food.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + food + "[/color] Provisions"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();
				local lowestChance = 9000;
				local lowestBro;
				local applied = false;

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Ratcatcher.getID())
					{
						continue;
					}

					local chance = bro.getHitpoints() + 20;

					if (bro.getSkills().hasSkill("trait.strong"))
					{
						chance = chance + 20;
					}

					if (bro.getSkills().hasSkill("trait.tough"))
					{
						chance = chance + 20;
					}

					for( ; this.Math.rand(1, 100) < chance; )
					{
						if (chance < lowestChance)
						{
							lowestChance = chance;
							lowestBro = bro;
						}
					}

					applied = true;
					local effect = this.new("scripts/skills/injury/sickness_injury");
					bro.getSkills().add(effect);
					this.List.push({
						id = 10,
						icon = effect.getIcon(),
						text = bro.getName() + " est malade"
					});
				}

				if (!applied && lowestBro != null)
				{
					local effect = this.new("scripts/skills/injury/sickness_injury");
					lowestBro.getSkills().add(effect);
					this.List.push({
						id = 10,
						icon = effect.getIcon(),
						text = lowestBro.getName() + " est malade"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() < 30)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
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
		this.m.Score = candidates.len() * 3;
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

