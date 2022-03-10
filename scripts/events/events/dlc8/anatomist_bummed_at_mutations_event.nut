this.anatomist_bummed_at_mutations_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_bummed_at_mutations";
		this.m.Title = "During camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{%anatomist% is sitting near to the campfire. Almost too close. You pull him back a ways so he doesn\'t burn himself. He looks up, his face dotted with pustules and slathered in the grease of ones which have already popped.%SPEECH_ON%I\'m beginning to wonder if I made a great mistake in drinking that potion.%SPEECH_OFF%He scoots back toward the flames, and there\'s a sense in his eyes that he wants to pitch himself into it. You can\'t do much for him, mostly because he looks awfully gross at the moment and you\'d rather not touch him again. | You find %anatomist% standing beside the company wagon with a sleeve unfurled and his finger picking at some strange markings there. Curious, you ask if they are birthmarks. The anatomist turns, shaking his head. He lifts up his shirt to show that these markings are all over his body, mottling the flesh with unsightly colors which look rough to the touch, like scabs that cannot be peeled.%SPEECH_ON%The potion I drank did this and I know not what to with myself.%SPEECH_OFF%You nod and tell him it\'ll surely get better. He sighs and simply lowers his shirt and looks away. | %anatomist% stands over a bucket of water, looking at his darkened reflection in it. He sighs. You ask how he is doing, and he turns to reveal horrific rashes and boils upon his skin.%SPEECH_ON%I am not doing so well, to be honest. The concoction I imbibed seems to have had a gravely ill-effect on me, though I am being perhaps a little giving with my vocabulary there. I will survive, but it has wounded me in ways that are not just of the skin and the body, but of the mind. I thought myself distanced from such matters, but now, seeing my horrible face...I am in a state of perpetual unease.%SPEECH_OFF%You grab his shoulder and give it a squeeze, then pat him on the back and make some recommendations like he should drink some water and of course to not feel bad. You weren\'t ever that great at consoling other men, much less ones suffering from terrible maladies sprung from scientific madness. | %anatomist% the anatomist is in a despondent state. The potion he made, and was in such a hurry to drink, has resulted in his entire body being overcome with maladies ranging from rashes to boils to what appear to be unusual spasms and plenty of snot from the nose. You assure him that he will get better, but his horrific appearance is taking a toll on him. | The strange concoctions %anatomist% the anatomist has been making, are strange concoctions that he has also been drinking. Unsurprisingly, the effects have not been good: rashes, infections, smells, hair falling out, and more. While on the outside he proclaims that what he is doing is in the name of science, you can tell that all these maladies and disfigurations are debilitating to the man\'s morale. You can only hope he gets better with time. | Matters of science, which are far outside your understanding, always do seem to come with risks. You remember as a child that your friend took the risk of swinging out on a rope into a river, and by happenstance you all found out just how much weight a branch can hold while in the throes of Fall.\n\nNow, it seems %anatomist% the anatomist is finding out the debilitating nature of drinking one of his bizarre potions. He is overwhelmed with rashes and infections, and for some reason he is a siren to ants, who for who knows what reason now love to crawl on him at all hours of day and night. Hopefully, with time, these maladies will depart, and hopefully take the damned ants with them. | You always knew the anatomists to be a bit wrong in the head, but the way they\'ve been creating potions and drinking them has really floored you. Water alone can be poisonous if sipped from the wrong cup, nevermind wholesale concoctions which are distilled in the mire of whatever scientific notions the anatomists are carrying that day. Naturally, it isn\'t long until one of the eggheads, %anatomist%, falls ill. He is still capable of moving and day-to-day tasks, but the giant warts and leaking pustules makes him a horror to look at, and though he may see himself distanced from society, you\'ve little doubt that walking around looking like a rag that\'s mopped up pigshite is healthy for the mind and spirit. Hopefully, with a bit of time, he might get better. | %anatomist% isn\'t necessarily sick from drinking his potions. After all, he is still able to move and get around, and even fight if necessary. But he is certainly affected by said potions in a manner most unsightly. Great boils have appeared on his cheeks, and occasionally his eyes spring from their sockets and he has to push them back in which is something you wished you hadn\'t seen. Strings of drool come down the corners of his lips and his nostril is home to snails of snot and boogers and blood. As you can imagine, he is rather down about the whole looking uglier than a dead pig carcass-thing, but you\'ve faith that in good time he will get better.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Feel better soon, %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.25, "Upset at how his mutations have changed him");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.getFlags().add("gotUpsetAtMutations");
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getFlags().has("gotUpsetAtMutations") && bro.getFlags().getAsInt("ActiveMutations") > 0)
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 6 * anatomistCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

