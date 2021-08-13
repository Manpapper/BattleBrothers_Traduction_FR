this.have_z_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_renown";
		this.m.Duration = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Il y a eu peu de compagnies de mercenaires légendaires à travers l\'histoire. Nous sommes sur le point de voir notre nom devenir immortel et d\'être compté parmi eux !";
		this.m.UIText = "Atteindre le rang de renom \"Invincible\"";
		this.m.TooltipText = "Devenez connu en étant \"Invincible\" (8 000 renommées) et laissez votre marque dans l\'histoire. Vous pouvez augmenter votre renommée en remplissant des contrats et en gagnant des batailles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Avec des rivières de sang, une centaine de forteresses brûlées et dix mille corbeaux gras et gourmands vous suivant, les récits des prouesses de votre compagnie ne mourront jamais. Le nom \"%companyname%\" est prononcé dans des cris de triomphe et de respect silencieux dans tous les coins du monde connu. Les pères donnent à leurs fils le nom de vos hommes les plus courageux, et ces garçons grandissent en jouant les nombreuses batailles célèbres que vous avez livrées.\n\nVotre renom est telle qu\'il est devenu gênant de visiter tout endroit plus grand qu\'un hameau. Partout où vous voyagez, vous êtes harcelé jour et nuit. Les jeunes filles qui se disputent l\'attention des hommes finissent par se battre. Les commerçants, vous croyant magnifiquement riche, vous appellent à toute heure avec leurs marchandises. Le pire, c\'est que tous les fanfarons du pays veulent défier vos hommes, et la milice attend le résultat, en espérant que la simple amende pour bagarre devienne une dette de sang.\n\nMais vous avez atteint votre objectif, même si le résultat n\'est pas tout à fait ce que vous aviez prévu. Quel que soit votre destin, %companyname% est déjà devenu immortel dans l\'histoire du monde.";
		this.m.SuccessButtonText = "Le nom de %companyname% vivra à jamais !";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 60)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() <= 4000 || this.World.Assets.getBusinessReputation() >= 7800)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 8000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(15);
			}
			else
			{
				this.World.Assets.updateLook(3);
			}

			this.m.SuccessList.push({
				id = 10,
				icon = "ui/icons/special.png",
				text = "Votre apparence sur la carte du monde a été mise à jour."
			});
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

