this.fear_greenskins_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.fear_greenskins";
		this.m.Title = "During camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%brother% stares at the campfire with his hands bridged between his knees.%SPEECH_ON%Fark, man. I don\'t know if I can look at a greenskin again. They\'re so much stronger and faster than us! We, we shouldn\'t face them again until we got at least, two, no three times as many men!%SPEECH_OFF%You tell the company to keep an eye on him. Fear is justified but spreading it sure as hell ain\'t.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is taking a toll on the men.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_greenskins_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " now fears greenskins"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 2)
		{
			return;
		}

		if (fallen[0].Time < this.World.getTime().Days || fallen[1].Time < this.World.getTime().Days)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.companion" || bro.getBackground().getID() == "background.orc_slayer" || bro.getBackground().getID() == "background.wildman")
			{
				continue;
			}

			if (bro.getLevel() <= 7 && !bro.getSkills().hasSkill("trait.fear_greenskins") && !bro.getSkills().hasSkill("trait.hate_greenskins") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.determined") && !bro.getSkills().hasSkill("trait.bloodthirsty"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brother",
			this.m.Casualty.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
	}

});

