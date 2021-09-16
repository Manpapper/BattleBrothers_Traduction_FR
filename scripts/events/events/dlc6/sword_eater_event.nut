this.sword_eater_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.sword_eater";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{A sword eater is dancing around a plaza of %townname%. He holds out a blade about as thick as your pinky.%SPEECH_ON%As the Gilder sees me, I will eat this steel!%SPEECH_OFF%The man announces his intent, and follows through promptly: he arches his back, pinches the blade, and glides it into his mouth and onward and inward, his mouth puckering around the steel as though he were slurping noodles. The crowd at first gasps, but then the swallower gives two thumbs up and the onlookers cheer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Bravo! Here\'s a few coins for you.",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Bravo! Give that guy a few coins from me, %wildman%.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				this.Options.push({
					Text = "Interesting way to earn a living.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You toss the man a few crowns. He pulls out his sword and places its tip upon his pate. The crowd cheers again. Grinning, the man talks as he balances the sword.%SPEECH_ON%I see your banner, Crownling. I\'m no warrior, but I am a traveler and well enough speaker. Though I seek to impress for personal gain, I will on occasion make sure to put in a kind word for your company of coin-seeking misfits.%SPEECH_OFF%The swallower throws his arms wide and nods quickly. The blade plummets from his skull and falls deftly into his sheathe at his hip. Again, the crowd roars with delight and you can\'t help but think this entertainer is a man of his word.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "My sword is not so sharp, yet the ladies can\'t even do that?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-5);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]5[/color] Crowns"
					}
				];
				_event.m.Town.getOwner().addPlayerRelation(5.0, "Local entertainers spread the word about you");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You hand %wildman% a few crowns and tell him to tip the entertainer. He grunts and heads over, then you realize that wasn\'t just any sellsword you beckoned, but %wildman% the wildman! Before you can stop him, he pushes the sword swallower over. There are cries, screams, and blood gargling death throes, but the crowd sweeps in front of the action and blocks the view. The way it is relayed to you is that the blade came out the swallower\'s front with straps of esophagus or stomach hanging off it. You know this, because the wildman made sure to bring back the sword himself and you had to have it cleaned.\n\n How exactly he retrieved the blade during those moments of carnage is beyond you, though you imagine he escaped the ferocity of the crowd by sheer will, determination, and complete absence of moral judgments which frightens men of normal sensibilities. You ask a few of the sellswords to hide the wildman away as he\'ll need to lay low for a while.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good job, but also bad job.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-5);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]5[/color] Crowns"
					}
				];
				local item = this.new("scripts/items/weapons/fencing_sword");
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Town.getOwner().addPlayerRelation(-10.0, "Rumor is that a local entertainer was killed by one of your men");
				this.World.Flags.set("IsSwordEaterWildmanDone", true);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 100)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (this.Const.DLC.Wildmen && !this.World.Flags.get("IsSwordEaterWildmanDone") && bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Wildman = null;
	}

});

